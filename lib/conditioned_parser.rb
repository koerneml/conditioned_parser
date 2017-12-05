require 'conditioned_parser/version'

# Parses a document according to specified conditions
module ConditionedParser
  autoload :Condition, 'conditioned_parser/condition'
  autoload :ConditionBuilder, 'conditioned_parser/condition_builder'
  autoload :TextMatchCondition, 'conditioned_parser/text_match_condition'
  autoload :TextMatchConditionBuilder,
           'conditioned_parser/text_match_condition_builder'
  autoload :Document, 'conditioned_parser/model/document'
  autoload :ModelBuilder, 'conditioned_parser/model/model_builder'

  module Model
    autoload :ModelBuilder, 'conditioned_parser/model/model_builder'
    autoload :ContentElement, 'conditioned_parser/model/content_element'
    autoload :Document, 'conditioned_parser/model/document'
    autoload :Line, 'conditioned_parser/model/line'
    autoload :Page, 'conditioned_parser/model/page'
    autoload :PageRegion, 'conditioned_parser/model/page_region'
    autoload :PageTemplate, 'conditioned_parser/model/page_template'
    autoload :TextBlock, 'conditioned_parser/model/text_block'
    autoload :Word, 'conditioned_parser/model/word'
  end

  def self.load_document(raw_data)
    Model::ModelBuilder.build_model_data(raw_data)
  end

  def self.with_document(document, &block)
    condition_builder = ConditionBuilder.new(document)
    condition_builder.instance_eval(&block) if block_given?
  end
end
