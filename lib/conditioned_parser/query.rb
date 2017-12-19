module ConditionedParser
  # Applies a query from dsl query specification
  class Query
    include Filter
    include Matcher
    attr_accessor :search_scope

    def initialize(document)
      @search_scope = document.pages
    end

    def as_text_block(options = {})
      # TODO: Implement
    end

    def as_text_lines(options = {})
      @search_scope = Model::ModelBuilder.build_lines(@search_scope, options)
    end

    def font_size(range)
      @search_scope = @search_scope.select { |element| range.include?(element.height) }
    end

    def page(num)
      @search_scope = filter_search_scope_by_page_no(num)[0].sub_elements
    end

    def pages(range)
      conflated_pages = []
      @search_scope.select { |page| range.include?(page.page_no) }.each_with_object(conflated_pages) do |page, memo|
        (memo << page.sub_elements).flatten!
      end
      @search_scope = conflated_pages
    end

    def pattern(expression)
      @match_pattern = expression
      @search_scope = match_search_scope_by(expression)
    end

    def region(identifier)
      @page_regions.select! { |region| region.identifier == identifier }
      @search_scope = @search_scope.select { |element| @page_regions.any? { |region| element.contained_in?(region) } }
    end

    def result
      result_hsh = {}
      matches = []
      @search_scope.each do |element|
        matches << element.match(@match_pattern)
      end
      result_hsh[@search_item] = matches
      result_hsh
    end

    def result?
      !@search_scope.empty?
    end

    def search_item_name(item)
      @search_item = item
    end

    def with_template(template_data)
      @page_regions = Model::PageTemplateBuilder.build_template(template_data)
    end
  end
end
