module ConditionedParser
  module Model
    # defines a page region, which essentially is a box
    class PageRegion
      include Box

      attr_accessor :identifier

      def initialize(box, identifier)
        @identifier = identifier
        @x_start = box[:x_start]
        @x_end = box[:x_end]
        @y_start = box[:y_start]
        @y_end = box[:y_end]
        @width = @x_end - @x_start
        @height = @y_end - @y_start
      end
    end
  end
end
