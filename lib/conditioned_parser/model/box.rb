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

      def on_same_line?(other, options = {})
        defaults = { y_tolerance: 0.5, height_tolerance: 2.0 }
        options = defaults.merge(options)
        # boxes are considered to be on the same line if their y_start and height are similar
        (y_start - other.y_start).abs <= options[:y_tolerance] && (height - other.height).abs <= options[:height_tolerance]
      end

      def width
        x_end - x_start
      end

      def height
        y_end - y_start
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
