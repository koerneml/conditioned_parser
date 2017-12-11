module ConditionedParser
  # Applies a query from dsl query specification
  class Query
    def initialize(raw_data)
      @raw_data = raw_data
      @document = Model::ModelBuilder.build_model(raw_data)
    end

    def constraints(&block)
      @current_doc = @document.dup # shallow here! watch out when modifying!
      instance_eval &block if block_given?
    end

    def result
      result_hsh = {}
      matches = []
      @current_doc.pages.each do |page|
        page.content_elements.each do |content|
          matches << content.contained_text
        end
      end
      result_hsh[@search_item] = matches
      result_hsh
    end

    def result?
      @current_doc.pages.any? do |page|
        !page.content_elements.empty?
      end
    end

    def page(value, &block)
      filter(:page, value, &block)
    end

    def pages(range, &block)
      filter(:pages, range, &block)
    end

    def pattern(value, &block)
      filter(:pattern, value, &block)
    end

    def region(value, &block)
      filter(:region, value, &block)
    end

    def search_item(value, &block)
      @search_item = value
      instance_eval &block if block_given?
    end

    def with_template(template_data, &block)
      view(template_data, &block)
    end

    private

    def filter(type, value, &block)
      case type
      when :page
        @current_doc.pages.select! { |page| page.page_no == value }
      when :pages
        @current_doc.pages.select! { |page| value.include?(page.page_no) }
      when :region
        @current_doc.pages.each do |page|
          page.content_elements.select! { |word| word.box.contained_in?(@template[value]) }
        end
      when :pattern
        @current_doc.pages.each do |page|
          page.content_elements.select! { |element| element.contained_text.match(value) }
        end
      when :font_size
      end
      instance_eval &block if block_given?
    end

    def group(type, options = {}, &block)
      case type
      when :letters_to_word
        # :kerning_tolerance?
      when :words_to_line
        # :line_height_difference_tolerance
      when :Line_to_block
      end
      instance_eval &block if block_given?
    end

    def view(template_data, &block)
      @template = Model::PageTemplateBuilder.build_template(template_data)
      instance_eval &block if block_given?
    end
  end
end
