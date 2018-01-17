require_relative 'model/model_builder'

module ConditionedParser
  # Main extraction unit in DSL style
  class Extractor
    def initialize(&block)
      block[self] if block_given?
    end

    def extract(&block)
      @result_hsh = {}
      block[self] if block_given?
      @result_hsh
    end

    def load_document(document)
      @document = document
    end

    def on_page(num, &block)
      @page_scope = num - 1
      return unless block_given?
      block[self]
      @page_scope = nil
    end

    def on_each_page(&block)
      @document.pages.each do |page|
        on_page(page.page_no, &block)
      end
    end

    def using_template(template, &block)
      @template = template
      return unless block_given?
      block[self]
      @template = nil
    end

    def in_region(identifier, &block)
      @region_scope = @template.regions.find { |region| region.identifier == identifier }
      return unless block_given?
      block[self]
      @region_scope = nil
    end

    def get_location_for(pattern)
      # TODO: Maybe this needs to be more semantically accurate
      # Currently identifies the surrounding box of pattern - if pattern is a single word,
      # results are as expected, if there are multiple words, the returned box is the
      # whole line in which the pattern is contained
      # Also will NOT match any multiline patterns!
      filtered_elements = filter_scopes
      matched = filtered_elements.find { |element| element.matches?(pattern) }
      if matched.nil?
        # apply line aggregation in order to cover multiword patterns
        matched = Model::ModelBuilder.build_lines(filtered_elements).find { |element| element.matches?(pattern) }
      end
      return if matched.nil?
      matched.box
    end

    def get_text_for(name, aggregation, &block)
      if block_given?
        @table_box = nil
        @column_definitions = []
        block[self]
      end
      # append to hash contents, in case some keys are used multiple times
      # e.g. contents on different pages belonging together
      ((@result_hsh[name] ||= []) << get_local_result(aggregation)).flatten!
      @result_hsh
    end

    def define_table_box(x_start, y_start, x_end, y_end)
      @table_box = define_box(x_start, y_start, x_end, y_end)
    end

    def define_search_box(x_start, y_start, x_end, y_end, &block)
      s_box = define_box(x_start, y_start, x_end, y_end)
      @search_box = Model::ModelBuilder.define_search_region(s_box)
      return unless block_given?
      block[self]
      @search_box = nil
    end

    def add_column(name, width, opts = {})
      default_opts = {
        right_overlap: 0.0
      }
      default_opts.merge!(opts)
      @column_definitions << { name: name, width: width, options: default_opts }
    end

    def get_local_result(aggregation)
      filtered_elements = filter_scopes
      case aggregation
      when :as_lines
        extract_as_lines(filtered_elements)
      when :as_blocks
        extract_as_blocks(filtered_elements)
      when :as_table
        extract_as_table(filtered_elements)
      else
        raise 'Invalid aggregation option'
      end
    end

    def result_hash
      @result_hsh
    end

    private

    def extract_as_blocks(elements)
      Model::ModelBuilder.build_blocks_from_words(elements).each_with_object([]) do |text_block, result|
        result << text_block.contained_text
      end
    end

    def extract_as_lines(elements)
      Model::ModelBuilder.build_lines(elements).each_with_object([]) do |line, result|
        result << line.contained_text
      end
    end

    def extract_as_table(elements)
      # assume region scope as table box, if no table box has been defined
      define_table_box(@region_scope.x_start, @region_scope.y_start, @region_scope.x_end, @region_scope.y_end) if @table_box.nil?
      table_region = Model::ModelBuilder.define_search_region(@table_box)
      table_content = elements.select { |element| element.contained_in?(table_region) }
      table = Model::ModelBuilder.build_table(table_content, table_region, @column_definitions)
      table.generate_table_hash
    end

    def filter_scopes
      current_page = @document.pages[@page_scope]
      elements = if @region_scope.nil?
                   current_page.sub_elements
                 else
                   current_page.sub_elements.select { |element| element.contained_in?(@region_scope) }
                 end
      unless @search_box.nil?
        elements = elements.select { |element| element.contained_in?(@search_box) }
      end
      elements
    end

    def define_box(x_start, y_start, x_end, y_end)
      {
        x_start: x_start,
        y_start: y_start,
        x_end: x_end,
        y_end: y_end
      }
    end
  end
end
