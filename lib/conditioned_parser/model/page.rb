module ConditionedParser
  module Model
    # Represents a page in the document to be queried
    class Page
      attr_accessor :page_no
      attr_accessor :content_elements

      def initialize(page_no, width, height)
        @page_width = width
        @page_height = height
        @page_no = page_no
      end

      def fill_in_data(page_data)
        @content_elements = []
        page_data.each do |word|
          @content_elements << Word.new(Box.new(word.attributes["xMin"].to_f, word.attributes["xMax"].to_f, word.attributes["yMin"].to_f, word.attributes["yMax"].to_f), word.to_s)
        end
        # TODO: Non-Nori version here:
        # page_data.each do |word|
        #   @content_elements << Word.new(Box.new(word[:x_start], word[:x_end], word[:y_start], word[:y_end]), word[:text])
        # end
      end
    end
  end
end
