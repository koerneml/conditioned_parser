module ConditionedParser
  module QueryEngine
    # location selector on documents - filters content according to selection information specified in query
    class Selector
      def initialize(document, select_info)
        @document = document
        @selectors = select_info
      end

      def select_content
        applicable_pages = filter_pages
        applicable_regions = filter_regions_from_pages(applicable_pages)
        # aggregate text in identified regions
        selected_content = ''
        applicable_regions.each do |region_hash|
          selected_content << region_hash.values.inject('') do |memo, region|
            memo << region.contained_text << ' '
          end
        end
        selected_content
      end

      def filter_pages
        if @selectors[:page]
          if @selectors[:page].is_a? Range
            @document.pages.select { |page| @selectors[:page].include?(page.page_no) }
          else
            @document.pages.select { |page| page.page_no == @selectors[:page] }
          end
        else
          @document.pages
        end
      end

      def filter_regions_from_pages(pages)
        applicable_regions = pages.inject([]) do |memo, page|
          memo << page.page_regions
        end
        if @selectors[:page_region]
          applicable_regions = applicable_regions.map do |regions_per_page|
            regions_per_page.select(@selectors[:page_region])
          end
        end
        applicable_regions
      end
    end
  end
end
