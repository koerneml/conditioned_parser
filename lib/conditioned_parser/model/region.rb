require_relative 'box'

module ConditionedParser
  # A complete region is specified via defining a box in 3 possible variations:
  # TODO:1) Giving all outer distances of the box to the page borders
  # TODO:2) Giving an absolute starting point, height, and width of the box
  # 3) Giving two absolute point coordinates defining the box
  module Model
    # Represents a named region in a template
    class Region
      include Box
      attr_reader :identifier

      def initialize(identifier)
        @identifier = identifier
      end

      def define_box
        if size_based_definition?
          define_size_box
        elsif point_based_definition?
          # do nothing as everything is defined
        else
          raise 'Incomplete or inconsistent region definition'
        end
      end

      def legal_region_definition?
        dist_based_definition? || size_based_definition? || point_based_definition?
      end

      private

      def dist_based_definition?
        @left_dist && @lower_dist && @right_dist && @upper_dist
      end

      def size_based_definition?
        x_start && y_start && @height && @width
      end

      def point_based_definition?
        x_start && x_end && y_start && y_end
      end

      def define_dist_box(page)
        @x_start = @left_dist + page.x_start
        @x_end = page.x_end - @right_dist
        @y_start = @upper_dist + page.y_start
        @y_end = page.y_end - @lower_dist
      end

      def define_size_box
        @x_end = x_start + @width
        @y_end = y_start + @height
      end
    end
  end
end
