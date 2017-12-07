module ConditionedParser
  module Model
    # represents a box with 4 coordinates
    class Box
      attr_accessor :x_start, :x_end, :y_start, :y_end

      def initialize(x_start, x_end, y_start, y_end)
        @x_start = x_start
        @x_end = x_end
        @y_start = y_start
        @y_end = y_end
      end

      def contained_in?(other)
        other.x_start <= x_start && other.x_end >= x_end && other.y_start <= y_start && other.y_end >= y_end
      end

      def contains?(other)
        other.x_start >= x_start && other.x_end <= x_end && other.y_start >= y_start && other.y_end <= y_end
      end
    end
  end
end
