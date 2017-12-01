require 'conditioned_parser/version'

# Parses a document according to specified conditions
module ConditionedParser
  autoload :Condition, 'conditioned_parser/condition'
  autoload :ConditionBuilder, 'conditioned_parser/condition_builder'
  autoload :TextMatchCondition, 'conditioned_parser/text_match_condition'
  autoload :TextMatchConditionBuilder,
           'conditioned_parser/text_match_condition_builder'
  autoload :Document, 'conditioned_parser/document'

  def self.with_document(document, &block)
    condition_builder = ConditionBuilder.new(document)
    condition_builder.instance_eval(&block) if block_given?
  end
end
