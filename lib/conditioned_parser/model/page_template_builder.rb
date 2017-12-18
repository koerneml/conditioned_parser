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
        regions.each_with_object([]) do |region, memo|
          region_box = {
            x_start: region[:x_start],
            x_end: region[:x_end],
            y_start: region[:y_start],
            y_end: region[:y_end]
          }
          memo << PageRegion.new(region_box, region[:identifier])
        end
      end
    end
  end
end
