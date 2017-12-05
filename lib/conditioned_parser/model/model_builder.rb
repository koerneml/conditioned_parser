module ConditionedParser
  module Model
    class ModelBuilder
      def self.build_model_data(raw_data)
        document = Document.new
        raw_data[:document][:pages].each do |page|
          new_page = Page.new(page[:page_no], page[:width], page[:height])
          new_page.fill_in_data(page[:words])
          document.pages << new_page
        end
        document
      end
    end
  end
end
