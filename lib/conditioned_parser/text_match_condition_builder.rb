module ConditionedParser
  # builds a text match condition from specified attributes
  class TextMatchConditionBuilder
    def initialize(text_item)
      @text_item = text_item
    end

    def matching_a_pattern(pattern)
      text_condition = TextMatchCondition.new
      text_condition.pattern = pattern
      text_condition.item = @text_item
      text_condition
    end

    def over_multiple_lines(line_def)
      # TODO: implement
      # line_def may default to single line
      # or being an exact value
      # or (maybe) a range
    end

    def with_font_size(font_def)
      # TODO: implement
      # font size can be defined exact
      # or with min: and max:
    end
  end
end
