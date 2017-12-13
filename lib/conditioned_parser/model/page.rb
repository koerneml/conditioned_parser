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
        @content_elements = []
      end
    end
  end
end
