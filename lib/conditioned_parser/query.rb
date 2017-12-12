module ConditionedParser
  # Applies a query from dsl query specification
  class Query
    def initialize(raw_data)
      @raw_data = raw_data
      @document = Model::ModelBuilder.build_model(raw_data)
    end

    def constraints(&block)
      @current_doc = @document.dup # shallow here! watch out when modifying!
      instance_eval(&block) if block_given?
    end

    def font_size(value, &block)
      # TODO: Implement
    end

    def text_lines(options = {}, &block)
      # TODO: Implement
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

    def page(num, &block)
      @current_doc.pages.select! { |page| page.page_no == num }
      instance_eval(&block) if block_given?
    end

    def pages(range, &block)
      @current_doc.pages.select! { |page| range.include?(page.page_no) }
      instance_eval(&block) if block_given?
    end

    def pattern(value, &block)
      @current_doc.pages.each do |page|
        page.content_elements.select! { |element| element.contained_text.match(value) }
      end
      instance_eval(&block) if block_given?
    end

    def region(identifier, &block)
      @current_doc.pages.each do |page|
        page.content_elements.select! { |word| word.box.contained_in?(@template[identifier]) }
      end
      instance_eval(&block) if block_given?
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
