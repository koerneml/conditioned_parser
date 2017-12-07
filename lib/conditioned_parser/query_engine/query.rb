module ConditionedParser
  module QueryEngine
    # represents a query on a document
    class Query
      attr_accessor :conditions

      def initialize
        @conditions = []
      end

      def result?
        @conditions.none? { |condition| !condition.evaluate? }
      end
    end
  end
end
