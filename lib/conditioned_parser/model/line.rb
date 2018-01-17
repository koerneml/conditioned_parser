module ConditionedParser
  module Model
    # Represents a line consisting of word elements
    class Line < ContentElement
      def contained_text
        super << "\n"
      end

      def contained_text_with_spacing(space_size)
        text = ''
        subs = sub_elements.dup
        until subs.empty?
          current = subs.shift
          text << current.contained_text
          next if subs.empty?
          text << ' ' * (current.x_distance_to(subs.first) / space_size).to_i
        end
        text << "\n"
      end

      def split_by_x_distance(max_distance)
        splits = []
        subs = sub_elements.dup
        until subs.empty?
          current_split = [subs.shift]
          until subs.empty? || (current_split.last.x_distance_to(subs.first) > max_distance)
            current_split << subs.shift
          end
          splits << Line.new(surrounding_box_for(current_split), current_split)
        end
        splits
      end

      def inspect
        "#<#{self.class.name}: x_start: #{x_start}, x_end: #{x_end}, y_start: #{y_start}, y_end: #{y_end}, contained_text: #{contained_text}"
      end

      private

      def surrounding_box_for(content_elements)
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
