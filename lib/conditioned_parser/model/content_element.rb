module ConditionedParser
  module Model
    # Represents a basic content element in the document. Each element consists of a bounding box defining its
    # size and contained elements
    class ContentElement
      attr_accessor :box
      attr_accessor :sub_elements

      def initialize(box, sub_elements = nil)
        @box = box
        @sub_elements = [] if (@sub_elements = sub_elements).nil?
      end

      def contained_text
        # OPTIMIZE: Seems elegant but is most likely O(my god) for actual pdf docs
        @sub_elements.inject('') do |memo, sub|
          memo << ' ' << sub.contained_text
        end
      end
    end
  end
end
