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
        @width = x_end - x_start
        @height = y_end - y_start
      end

      def contained_in?(other)
        other.x_start <= x_start && other.x_end >= x_end && other.y_start <= y_start && other.y_end >= y_end
      end

      def contains?(other)
        other.x_start >= x_start && other.x_end <= x_end && other.y_start >= y_start && other.y_end <= y_end
      end

      def x_distance(other)
        if other.x_start >= x_end
          other.x_start - x_end
        else
          x_start - other.x_end
        end
      end

      def y_distance(other)
        if other.y_start >= y_end
          other.y_start - y_end
        else
          y_start - other.y_end
        end
      end
    end
  end
end
