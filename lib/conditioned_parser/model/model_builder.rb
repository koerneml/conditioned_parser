module ConditionedParser
  module Model
    # constructs and aggregates model data
    class ModelBuilder
      def self.build_line(words)
        Line.new(surrounding_box_for(words), words)
      end

      def self.build_lines(words, options = {})
        lines = []
        words = words.dup
        until words.empty?
          new_line = [words.shift]
          (new_line << words.select { |word| word.on_same_line?(new_line.first, options) }).flatten!
          words.reject! { |word| word.on_same_line?(new_line.first) }
          lines << build_line(new_line)
        end
        lines
      end

      def self.build_blocks_from_lines(lines, _options = {})
        [TextBox.new(surrounding_box_for(lines), lines)]
      end

      def self.build_blocks_from_words(words, options = {})
        lines = build_lines(words)
        build_blocks_from_lines(lines, options)
      end

      def self.surrounding_box_for(content_elements)
        {
          x_start: content_elements.min_by(&:x_start).x_start,
          x_end: content_elements.max_by(&:x_end).x_end,
          y_start: content_elements.min_by(&:y_start).y_start,
          y_end: content_elements.max_by(&:y_end).y_end
        }
      end
    end
  end
end
