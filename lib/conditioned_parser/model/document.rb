module ConditionedParser
  module Model
    class Document
      attr_accessor :pages

      def initialize
        @pages = Array.new
      end
    end
  end
end
