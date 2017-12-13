module ConditionedParser
  module Model
    # Represents a single word in the document
    class Word < ContentElement
      attr_accessor :text

      def initialize(box, text)
        super(box)
        @text = text
      end

      def contained_text
        @text
      end

      def inspect
        "#<#{self.class.name}: x_start: #{x_start}, x_end: #{x_end}, y_start: #{y_start}, y_end: #{y_end}, contained_text: #{contained_text}"
      end
    end
  end
end
