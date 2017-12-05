module ConditionedParser
  module Model
    class Word < ContentElement
      attr_accessor :text

      def initialize(x_start, x_end, y_start, y_end, text)
        super(x_start, x_end, y_start, y_end)
        @text = text
      end

      def contained_text
        @text
      end
    end
  end
end
