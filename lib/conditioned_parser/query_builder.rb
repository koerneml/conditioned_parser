module ConditionedParser
  # Builds a query hash from dsl-style query specification
  class QueryBuilder
    def initialize(document)
      @document = document
      @query_data = { query: { must: [], must_not: [] } }
      @condition_template = { location: {}, text_options: {} }
    end

    def i_want_that
      @type = :must
    end

    def i_dont_want_that
      @type = :must_not
    end

    def on_page(num)
      @condition_template[:location][:page] = num
    end

    def in_region(region)
      @condition_template[:location][:region] = region
    end

    def there_is_text
      # TODO: Does this even work that way?!
      yield if block_given?
      @query_data[:query][:must] << @condition_template
      @condition_template = { location: {}, text_options: {} }
      @query_data
    end

    def matching_a_pattern(pattern)
      @condition_template[:text_options][:pattern] = pattern
    end

    def over_multiple_lines(line_def)
      # TODO: implement
    end

    def with_font_size(font_def)
      # TODO: implement
    end
  end
end
