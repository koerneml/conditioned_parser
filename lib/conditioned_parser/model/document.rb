module ConditionedParser
  module Model
    # Representation of a document to be queried
    class Document
      include Filter
      attr_accessor :pages

      def initialize
        @pages = []
      end
    end
  end
end
