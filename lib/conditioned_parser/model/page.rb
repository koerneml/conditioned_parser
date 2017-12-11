module ConditionedParser
  module Model
    # Represents a page in the document to be queried
    class Page
      attr_accessor :page_no
      attr_accessor :page_regions

      def initialize(page_no, width, height, template_data = {})
        @page_width = width
        @page_height = height
        @page_regions = PageTemplateBuilder.build_template(width, height, template_data)
        @page_no = page_no
      end

      def fill_in_data(page_data)
        # TODO: For now, fill words only
        page_data.each do |word|
          new_word = Word.new(Box.new(word[:x_start], word[:x_end], word[:y_start], word[:y_end]), word[:text])
          @page_regions.each do |identifier, region|
            region.sub_elements << new_word if region.box.contains?(new_word.box)
          end
        end
      end

      # TODO: Development adapter to obtain test data
      def fill_in_nori_data(page_data)
        page_data.each do |word|
          new_word = Word.new(Box.new(word.attributes["xMin"].to_f, word.attributes["xMax"].to_f, word.attributes["yMin"].to_f, word.attributes["yMax"].to_f), word.to_s)
          @page_regions.each do |identifier, region|
            region.sub_elements << new_word if region.box.contains?(new_word.box)
          end
        end
      end
    end
  end
end
