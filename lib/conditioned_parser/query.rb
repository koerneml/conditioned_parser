module ConditionedParser
  # Applies a query from dsl query specification
  class Query
    attr_accessor :search_scope

    # Using a dedicated search scope allows for modifications on the elements without manipulating the original document object
    # Hence, deep copys of the document are not needed when applying multiple queries in sequence
    # Nonetheless, modifications on the scope have to be done with care, the referenced objects are still contained in the document
    # -> only invoke methods returning new_ary
    def initialize(document)
      @search_scope = document.pages
    end

    def as_text_block(options = {})
      @search_scope = Model::ModelBuilder.build_block(@search_scope, options)
    end

    def as_text_lines(options = {})
      @search_scope = Model::ModelBuilder.build_lines(@search_scope, options)
    end

    def font_size(range)
      @search_scope = @search_scope.select { |element| range.include?(element.height) }
    end

    def page(num)
      @search_scope = @search_scope.select { |page| page.page_no == num }[0].sub_elements
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
      @search_scope = @search_scope.select { |element| element.matches?(expression) } 
    end

    def region(identifier)
      @page_regions = @page_regions.select { |region| region.identifier == identifier }
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

    def with_template(template)
      @page_regions = template.regions
    end
  end
end
