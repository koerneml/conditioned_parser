module ConditionedParser
  module QueryEngine
    # generates query object based on query_data
    class QueryParser
      def self.generate_query(query_data, document)
        query = Query.new
        query_data[:query].each do |cond_type, condition_list|
          condition_list.each do |condition_data|
            query.conditions << generate_condition(document, condition_data, cond_type)
          end
        end
        query
      end

      def self.generate_condition(document, condition_data, condition_type)
        selector = Selector.new(document, condition_data[:location])
        if condition_data[:text_options]
          new_condition = TextMatchCondition.new(condition_data[:text_options][:pattern], selector, condition_type)
        end
        new_condition
      end
    end
  end
end
