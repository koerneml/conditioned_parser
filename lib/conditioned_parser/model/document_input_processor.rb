require_relative 'document'
require_relative 'page'
require_relative 'word'

module ConditionedParser
  module Model
    # Processes raw input data to generate an initial document representation
    class DocumentInputProcessor
      def self.build_document(raw_data)
        ensure_array(raw_data['html']['body']['doc']['page']).each_with_index.each_with_object(Document.new) do |(page_data, idx), doc|
          doc.pages << build_page(idx + 1, page_data)
        end
      end

      def self.build_page(no, page_data)
        new_page = Page.new(define_page_box(page_data['@width'], page_data['@height']), no)
        ensure_array(page_data['word']).each_with_object(new_page) do |word_data, page|
          page.sub_elements << build_word(word_data)
        end
      end

      def self.define_page_box(width, height)
        {
          x_start: 0.0,
          x_end: width.to_f.round(2),
          y_start: 0.0,
          y_end: height.to_f.round(2)
        }
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

      def self.ensure_array(value)
        value.is_a?(Array) ? value : [value]
      end
    end
  end
end
