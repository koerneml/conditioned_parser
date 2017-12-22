module ConditionedParser
  module Model
    # represents a box with 4 coordinates
    module Box
      attr_accessor :x_start, :x_end, :y_start, :y_end

      def contained_in?(other)
        other.x_start <= x_start && other.x_end >= x_end && other.y_start <= y_start && other.y_end >= y_end
      end

      def contains?(other)
        other.x_start >= x_start && other.x_end <= x_end && other.y_start >= y_start && other.y_end <= y_end
      end

      def left_of?(other)
        x_end <= other.x_start
      end

      def right_of?(other)
        x_start >= other.x_end
      end

      def overlap?(other)
        x_overlap?(other) && y_overlap?(other)
      end

      def x_overlap?(other)
        (x_start..x_end).cover?(other.x_start) || (x_start..x_end).cover?(other.x_end)
      end

      def y_overlap?(other)
        (y_start..y_end).cover?(other.y_start) || (y_start..y_end).cover?(other.y_end)
      end

      def on_same_line?(other, options = {})
        defaults = { y_tolerance: 0.5, height_tolerance: 2.0 }
        defaults.merge!(options)
        # boxes are considered to be on the same line if their y_start and height are similar
        (y_start - other.y_start).abs <= defaults[:y_tolerance] && (height - other.height).abs <= defaults[:height_tolerance]
      end

      def width
        x_end - x_start
      end

      def height
        y_end - y_start
      end
    end
  end
end
