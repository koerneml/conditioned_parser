module ConditionedParser
  # Builds conditions as specified by attributes
  # Delegates complex behavior to sub-builders
  class ConditionBuilder
    def initialize(document)
      @document = document
      @page_range = 1..document.pages.size
    end

    def on_page(num)
      @page_range = num
    end

    def in_region(region)
      # TODO: define region limitation via condition
    end

    def there_is_text(&block)
      # TODO: select pages
      text_condition_builder = TextMatchConditionBuilder.new(@document.pages.first.page_template.page_regions[:complete_page])
      text_condition_builder.instance_eval(&block) if block_given?
    end
  end
end
