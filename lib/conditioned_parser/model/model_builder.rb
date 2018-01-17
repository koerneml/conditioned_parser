require_relative 'line'
require_relative 'word'
require_relative 'text_box'
require_relative 'table'
require_relative 'table_column'

module ConditionedParser
  module Model
    # constructs and aggregates model data
    class ModelBuilder
      def self.build_line(words)
        words.sort_by!(&:x_start)
        Line.new(surrounding_box_for(words), words)
      end

      def self.build_lines(words, options = {})
        # TODO: Spacing option
        lines = []
        words = words.dup
        until words.empty?
          new_line = [words.shift]
          (new_line << words.select { |word| word.on_same_line?(new_line.last, options) }).flatten!
          words.reject! { |word| word.on_same_line?(new_line.last, options) }
          lines << build_line(new_line)
        end
        lines
      end

      def self.build_blocks_from_lines(lines, _options = {})
        # TODO: outer distance option for blocks
        [TextBox.new(surrounding_box_for(lines), lines)]
      end

      def self.build_blocks_from_words(words, options = {})
        lines = build_lines(words)
        build_blocks_from_lines(lines, options)
      end

      def self.build_table(table_words, table_region, column_definitions)
        # Table rows are assumed to always be a line, hence row definitions
        # do solely rely on actual content instead of outside definitions
        content_as_lines = build_lines(table_words)
        columns = build_table_columns(table_region, column_definitions)
        Table.new(table_region.box, columns, content_as_lines)
      end

      def self.build_table_column(box, name, options)
        TableColumn.new(box, name, options)
      end

      def self.build_table_columns(table_region, column_definitions)
        current_col_x_start = table_region.x_start
        column_definitions.each_with_object([]) do |col_def, cols|
          col_box = define_box(current_col_x_start, table_region.y_start, current_col_x_start + col_def[:width], table_region.y_end)
          cols << build_table_column(col_box, col_def[:name], col_def[:options])
          current_col_x_start += col_def[:width]
        end
      end

      def self.define_search_region(box)
        # TODO: This is kind of a misuse of Regions to define search boxes
        # It does not feel as though this part of the gem should be able to
        # define stuff belonging to the templating
        table_region = Region.new(:search)
        table_region.box = box
        table_region
      end

      def self.surrounding_box_for(content_elements)
        {
          x_start: content_elements.min_by(&:x_start).x_start,
          x_end: content_elements.max_by(&:x_end).x_end,
          y_start: content_elements.min_by(&:y_start).y_start,
          y_end: content_elements.max_by(&:y_end).y_end
        }
      end

      def self.define_box(x_start, y_start, x_end, y_end)
        {
          x_start: x_start,
          y_start: y_start,
          x_end: x_end,
          y_end: y_end
        }
      end
    end
  end
end
