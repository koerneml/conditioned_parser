module ConditionedParser
  module Model
    # represents a box with 4 coordinates
    module Box
      attr_accessor :x_start, :x_end, :y_start, :y_end

      def box
        {
          x_start: x_start,
          y_start: y_start,
          x_end: x_end,
          y_end: y_end
        }
      end

      def box=(new_box)
        @x_start = new_box[:x_start]
        @y_start = new_box[:y_start]
        @x_end = new_box[:x_end]
        @y_end = new_box[:y_end]
      end

      def contained_in?(other)
        in_x_range_of?(other) && in_y_range_of?(other)
      end

      def contains?(other)
        other.x_start >= x_start && other.x_end <= x_end && other.y_start >= y_start && other.y_end <= y_end
      end

      def in_x_range_of?(other)
        other.x_start <= x_start && other.x_end >= x_end
      end

      def in_y_range_of?(other)
        other.y_start <= y_start && other.y_end >= y_end
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

      def x_distance_to(other)
        other.x_start - x_end
      end

      # left overlap means that the word box is overlapped by the other box to the left
      # i.e. self:    ---------
      #      other: ------
      def left_overlapped_by?(other)
        (x_start..x_end).cover?(other.x_end)
      end

      def right_overlapped_by?(other)
        (x_start..x_end).cover?(other.x_start)
      end

      def x_overlap?(other)
        right_overlapped_by?(other) || left_overlapped_by?(other)
      end

      def y_overlap?(other)
        (y_start..y_end).cover?(other.y_start) || (y_start..y_end).cover?(other.y_end)
      end

      def on_same_line?(other, options = {})
        defaults = { y_tolerance: 0.5, height_tolerance: 2.0 }
        defaults.merge!(options)
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
