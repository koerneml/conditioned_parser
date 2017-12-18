module ConditionedParser
  # Applies a query from dsl query specification
  class Query
    def initialize(document)
      @current_doc = document
    end

    def as_text_block(options = {})
      # TODO: Implement
    end

    def as_text_lines(options = {})
      lines = []
      @current_doc.pages.each do |page|
        page_lines = Model::ModelBuilder.build_lines(page.content_elements, options)
        (lines << page_lines).flatten!
      end
      lines
    end

    def font_size(value)
      # TODO: Implement
    end

    def page(num)
      @current_doc.filter_pages_by_page_no(num)
    end

    def pages(range)
      @current_doc.pages.select! { |page| range.include?(page.page_no) }
    end

    def pattern(expression)
      @match_pattern = expression
      @current_doc.pages.each do |page|
        page.match_content_elements_by(expression)
      end
    end

    def region(identifier)
      @current_doc.pages.each do |page|
        page.filter_page_regions_by_identifier(identifier)
        page.content_elements.select! { |element| page.page_regions.any? { |reg| element.contained_in?(reg) } }
      end
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

    def search_item(value)
      @search_item = value
    end

    def with_template(template_data)
      @current_doc.pages.each do |page|
        page.page_regions = Model::PageTemplateBuilder.build_template(template_data)
      end
    end
  end
end
