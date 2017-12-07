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
    end
  end
end
