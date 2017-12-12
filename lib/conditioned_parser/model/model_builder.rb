module ConditionedParser
  module Model
    # Builds the document object model based on raw data specification
    class ModelBuilder
      def self.build_model(raw_data)
        document = Document.new
        raw_data['html']['body']['doc']['page'].each_with_index.each_with_object([]) do |(page_data, idx), _memo|
          new_page = Page.new(idx + 1, page_data['@width'], page_data['@height'])
          new_page.fill_in_data(page_data['word'])
          document.pages << new_page
        end
        # TODO: original non-Nori loader here:
        # raw_data[:document][:pages].each do |page|
        #   new_page = Page.new(page[:page_no], page[:width], page[:height])
        #   new_page.fill_in_data(page[:words])
        #   document.pages << new_page
        # end
        document
      end

      def self.build_line(words)
        Line.new(surrounding_box_for(words), words)
      end

      def self.build_text_box(lines)
        TextBox.new(surrounding_box_for(lines), lines)
      end

      def self.surrounding_box_for(content_elements)
        x_min = content_elements.min_by { |element| element.box.x_start }
        x_max = content_elements.max_by { |element| element.box.x_end }
        y_min = content_elements.min_by { |element| element.box.y_start }
        y_max = content_elements.max_by { |element| element.box.y_end }
        Box.new(x_min, x_max, y_min, y_max)
      end
    end
  end
end
