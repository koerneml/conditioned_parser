module ConditionedParser
  module Model
    # Represents a page in the document to be queried
    class Page < ContentElement
      attr_accessor :page_no

      def initialize(box, page_no)
        super(box)
        @page_no = page_no
      end
    end
  end
end
