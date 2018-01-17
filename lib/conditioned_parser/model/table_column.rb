require_relative 'box'

module ConditionedParser
  module Model
    # Represents a column overlay for tables
    class TableColumn
      include Box

      attr_reader :identifier

      attr_reader :right_overlap

      def initialize(box, identifier, options)
        @identifier = identifier
        @x_start = box[:x_start]
        @y_start = box[:y_start]
        @x_end = box[:x_end]
        @y_end = box[:y_end]
        @right_overlap = options[:right_overlap]
      end

      def limit_to_column(words)
        last_contained_word = nil
        words.select do |word|
          # assume that each word overlapping in from the left belongs to the column,
          # words overlapping out to the right are subjected to the tolerance value
          in_column = false
          if contains?(word) || left_overlapped_by?(word) || (!last_contained_word.nil? && last_contained_word.x_distance_to(word) <= right_overlap)
            in_column = true
            last_contained_word = word
          end
          in_column
        end
      end
    end
  end
end
