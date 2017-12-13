module ConditionedParser
  module Model
    # Processes raw input data to generate an initial document representation
    class DocumentInputProcessor
      def self.build_model(raw_data)
        raw_data['html']['body']['doc']['page'].each_with_index.each_with_object(Document.new) do |(page_data, idx), doc|
          doc.pages << build_page(idx + 1, page_data)
        end
        # TODO: original non-Nori loader here:
      end

      def self.build_page(no, page_data)
        new_page = Page.new(no, page_data['@width'], page_data['@height'])
        page_data['word'].each do |word_data|
          new_page.content_elements << build_word(word_data)
        end
        new_page
      end

      def self.build_word(word_data)
        box = {
          x_start: word_data.attributes['xMin'],
          x_end: word_data.attributes['xMax'],
          y_start: word_data.attributes['yMin'],
          y_end: word_data.attributes['yMax']
        }
        Word.new(box, word_data.to_s)
      end
    end
  end
end
