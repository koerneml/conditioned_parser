require_relative 'box'

module ConditionedParser
  module Model
    # Represents a basic content element in the document. Each element consists of a bounding box defining its
    # size and contained elements
    class ContentElement
      include Box
      attr_accessor :sub_elements

      def initialize(box, sub_elements = [])
        define_box(box)
        @sub_elements = sub_elements
      end

      def define_box(box)
        @x_start = box[:x_start].to_f.round(2)
        @x_end = box[:x_end].to_f.round(2)
        @y_start = box[:y_start].to_f.round(2)
        @y_end = box[:y_end].to_f.round(2)
      end

      def contained_text
        # OPTIMIZE: Seems elegant but is most likely O(my god) for actual pdf docs
        text = @sub_elements.inject('') do |memo, sub|
          memo << sub.contained_text << ' '
        end
        text.strip
      end

      def inspect
        "#<#{self.class.name}: x_start: #{x_start}, x_end: #{x_end}, y_start: #{y_start}, y_end: #{y_end}, contained_text: #{contained_text}"
      end

      def matches?(expression)
        !match(expression).empty?
      end

      def match(expression)
        matching = contained_text.match(expression)
        if matching.nil?
          []
        else
          matching.to_a
        end
      end
    end
  end
end
