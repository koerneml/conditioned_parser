module ConditionedParser
  module Model
    # generates page_regions according to region specification
    class PageTemplateBuilder
      def self.build_no_template(width, height)
        region_data = [{ identifier: :complete_page, x_start: 0, x_end: width.to_f, y_start: 0, y_end: height.to_f }]
        create_template(region_data)
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
        create_template(region_data)
      end

      def self.add_region(box, page_regions, identifier)
        page_regions[identifier] = PageRegion.new(box)
      end

      def self.create_template(region_data)
        page_regions = {}
        region_data.each do |region|
          region_box = Box.new(region[:x_start], region[:x_end], region[:y_start], region[:y_end])
          page_regions[region[:identifier]] = PageRegion.new(region_box)
        end
        page_regions
      end

      def self.build_template(page_width, page_height, regions = {})
        if regions.empty?
          page_regions = build_no_template(page_width, page_height) if regions.empty?
        else
          page_regions = create_template(regions)
        end
        page_regions
      end
    end
  end
end
