module ConditionedParser
  module Model
    # Represents a line consisting of word elements
    class Line < ContentElement
      def contained_text
        super << "\n"
      end

      def inspect
        "#<#{self.class.name}: x_start: #{x_start}, x_end: #{x_end}, y_start: #{y_start}, y_end: #{y_end}, contained_text: #{contained_text}"
      end
    end
  end
end
