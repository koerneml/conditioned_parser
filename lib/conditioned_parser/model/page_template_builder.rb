module ConditionedParser
  module Model
    # generates page_regions according to region specification
    class PageTemplateBuilder
      def self.build_no_template(width, height)
        region_data = [{ identifier: :complete_page, x_start: 0, x_end: width.to_f, y_start: 0, y_end: height.to_f }]
        build_template(region_data)
      end

      def self.build_quadrant_template(width, height)
        # same as build_quadtants in Constants module
        half_width = width / 2.0
        half_height = height / 2.0
        region_data = [
          { identifier: :lower_left, x_start: 0, x_end: half_width.ceil, y_start: 0, y_end: half_height.ceil },
          { identifier: :lower_right, x_start: half_width.floor, x_end: width, y_start: 0, y_end: half_height.ceil },
          { identifier: :upper_left, x_start: 0, x_end: half_width.ceil, y_start: half_height.floor, y_end: height },
          { identifier: :upper_right, x_start: half_width.floor, x_end: width, y_start: half_height.floor, y_end: height }
        ]
        build_template(region_data)
      end

      def self.build_template(regions)
        page_regions = {}
        regions.each do |region|
          region_box = Box.new(region[:x_start], region[:x_end], region[:y_start], region[:y_end])
          page_regions[region[:identifier]] = region_box
        end
        page_regions
      end
    end
  end
end
