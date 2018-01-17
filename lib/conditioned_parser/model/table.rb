require_relative 'content_element'

module ConditionedParser
  module Model
    # represents a table in the document
    class Table < ContentElement
      # columns are a logical overlay, while lines are the ACTUAL subelements
      attr_accessor :columns

      def initialize(box, columns, content)
        super(box, content)
        @columns = columns
      end

      def generate_table_hash
        sub_elements.each_with_object([]) do |line, table|
          line_words = line.sub_elements.dup
          table << columns.each_with_object({}) do |column, row|
            cell_words = column.limit_to_column(line_words)
            line_words -= cell_words
            row[column.identifier] = cell_words.map(&:contained_text).join(' ')
          end
        end
      end
    end
  end
end
