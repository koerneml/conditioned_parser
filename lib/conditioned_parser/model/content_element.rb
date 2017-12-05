module ConditionedParser
  module Model
    class ContentElement
      attr_accessor :x_start, :x_end, :y_start, :y_end, :height, :width
      attr_accessor :sub_elements

      def initialize(x_start, x_end, y_start, y_end, sub_elements = nil)
        @x_start = x_start
        @x_end = x_end
        @y_start = y_start
        @y_end = y_end
        @height = y_end - y_start
        @width = x_end - x_start
        if sub_elements.nil?
          @sub_elements = Array.new
        else
          @sub_elements = sub_elements
        end
      end

      def is_contained_in(other)
        other.x_start <= self.x_start && other.x_end >= self.x_end && other.y_start <= self.y_start && other.y_end >= self.y_end
      end

      def contains?(other)
        other.x_start >= self.x_start && other.x_end <= self.x_end && other.y_start >= self.y_start && other.y_end <= self.y_end
      end

      def contained_text
        # OPTIMIZE: Seems elegant but is most likely O(my god) for actual pdf docs
        @sub_elements.inject(String.new) do |memo, sub|
          memo << ' ' << sub.contained_text
        end
      end
    end
  end
end
