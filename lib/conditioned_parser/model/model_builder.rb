module ConditionedParser
  module Model
    # Builds the document object model based on raw data specification
    class ModelBuilder
      def self.build_model_data(raw_data, dev, &block)
        document = Document.new
        if dev # TODO: Nori Dev adapter!
          raw_data["html"]["body"]["doc"]["page"].each_with_index.each_with_object([]) do |(page_data, idx), memo|
            new_page = Page.new(idx+1, page_data["@width"], page_data["@height"])
            new_page.fill_in_nori_data(page_data["word"])
            document.pages << new_page
          end
        else
          raw_data[:document][:pages].each do |page|
            new_page = Page.new(page[:page_no], page[:width], page[:height])
            new_page.fill_in_data(page[:words])
            document.pages << new_page
          end
        end
        document
      end
    end
  end
end
