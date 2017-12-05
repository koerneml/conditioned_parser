module ConditionedParser
  module Model
    class PageTemplate
      attr_accessor :page_regions

      def initialize(page_width, page_height, regions = {})
        # TODO: For now, we default to page template
        @page_width = page_width
        @page_height = page_height
        build_no_template
      end

      def build_no_template
        @page_regions = Hash.new
        @page_regions[:complete_page] = PageRegion.new(0, @page_width, 0, @page_height)
      end

      def build_quadrant_template
        # same as build_quadtants in Constants module
        half_width = @page_width / 2.0
        half_height = @page_height / 2.0
        @page_regions = Hash.new
        @page_regions[:lower_left] = PageRegion.new(0, half_width.ceil, 0, half_height.ceil)
        @page_regions[:lower_right] = PageRegion.new(half_width.floor, @page_width, 0, half_height.ceil)
        @page_regions[:upper_left] = PageRegion.new(0, half_width.ceil, half_height.floor, @page_height)
        @page_regions[:upper_right] = PageRegion.new(half_width.floor, @page_width, half_height.floor, @page_height)
      end
    end
  end
end
