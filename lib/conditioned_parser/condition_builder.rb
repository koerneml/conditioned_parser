module ConditionedParser
  # Builds conditions as specified by attributes
  # Delegates complex behavior to sub-builders
  class ConditionBuilder
    def initialize(document)
      @document = document
    end

    def on_page(num)
      # TODO: define page limitation via condition
    end

    def in_region(region)
      # TODO: define region limitation via condition
    end

    def there_should_be_text(&block)
      text_condition_builder = TextMatchConditionBuilder.new(@document.text)
      text_condition_builder.instance_eval(&block) if block_given?
    end
  end
end
