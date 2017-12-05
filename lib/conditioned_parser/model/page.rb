module ConditionedParser
  module Model
    class Page
      attr_accessor :page_template, :page_no

      def initialize(page_no, width, height)
        @page_template = PageTemplate.new(width, height)
        @page_no = page_no
      end

      def fill_in_data(page_data)
        # TODO: For now, fill words only
        page_data.each do |word|
          new_word = Word.new(word[:x_start], word[:x_end], word[:y_start], word[:y_end], word[:text])
          # TODO: dynamic select per template
          @page_template.page_regions[:complete_page].sub_elements << new_word
        end
      end
    end
  end
end
