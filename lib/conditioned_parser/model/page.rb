module ConditionedParser
  module Model
    # Represents a page in the document to be queried
    class Page
      attr_accessor :page_no
      attr_accessor :page_regions

      def initialize(page_no, width, height)
        @page_width = width
        @page_height = height
        @page_regions = PageTemplateBuilder.build_template(width, height)
        @page_no = page_no
      end

      def fill_in_data(page_data)
        # TODO: For now, fill words only
        page_data.each do |word|
          new_word = Word.new(Box.new(word[:x_start], word[:x_end], word[:y_start], word[:y_end]), word[:text])
          # TODO: dynamic select per template
          @page_regions[:complete_page].sub_elements << new_word
        end
      end
    end
  end
end
