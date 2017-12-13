module ConditionedParser
  # Applies a query from dsl query specification
  class Query
    def initialize(raw_data)
      @raw_data = raw_data
      @document = Model::DocumentInputProcessor.build_model(raw_data)
    end

    def as_text_block(options = {}, &block)
      # TODO: Implement
    end

    def as_text_lines(options = {}, &block)
      lines = []
      @current_doc.pages.each_with_index do |page, index|
        page_lines = Model::ModelBuilder.build_lines(page.content_elements, options)
        if block_given?
          # if we want to work on with this, we alter the document structure to contain the aggregation
          @current_doc.pages[index].content_elements = page_lines
        else
          (lines << page_lines).flatten!
        end
      end
      block_given? ? instance_eval(&block) : lines
    end

    def constraints(&block)
      @current_doc = @document.dup # shallow here! watch out when modifying!
      instance_eval(&block) if block_given?
    end

    def font_size(value, &block)
      # TODO: Implement
    end

    def page(num, &block)
      @current_doc.pages.select! { |page| page.page_no == num }
      instance_eval(&block) if block_given?
    end

    def pages(range, &block)
      @current_doc.pages.select! { |page| range.include?(page.page_no) }
      instance_eval(&block) if block_given?
    end

    def pattern(expression, &block)
      @match_pattern = expression
      @current_doc.pages.each do |page|
        page.content_elements.select! { |element| element.match(expression) }
      end
      instance_eval(&block) if block_given?
    end

    def region(identifier, &block)
      @current_doc.pages.each do |page|
        page.content_elements.select! { |word| word.contained_in?(@template[identifier]) }
      end
      instance_eval(&block) if block_given?
    end

    def result
      result_hsh = {}
      matches = []
      @current_doc.pages.each do |page|
        page.content_elements.each do |content|
          matches << content.match(@match_pattern)
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

    def search_item(value, &block)
      @search_item = value
      instance_eval(&block) if block_given?
    end

    def with_template(template_data, &block)
      view(template_data, &block)
    end

    private

    def view(template_data, &block)
      @template = Model::PageTemplateBuilder.build_template(template_data)
      instance_eval(&block) if block_given?
    end
  end
end
