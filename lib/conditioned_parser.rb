require 'conditioned_parser/version'

# Parses a document according to specified conditions
module ConditionedParser
  autoload :QueryBuilder, 'conditioned_parser/query_builder'

  # document representation
  module Model
    autoload :Box, 'conditioned_parser/model/box'
    autoload :ContentElement, 'conditioned_parser/model/content_element'
    autoload :Document, 'conditioned_parser/model/document'
    autoload :Line, 'conditioned_parser/model/line'
    autoload :ModelBuilder, 'conditioned_parser/model/model_builder'
    autoload :Page, 'conditioned_parser/model/page'
    autoload :PageRegion, 'conditioned_parser/model/page_region'
    autoload :PageTemplateBuilder, 'conditioned_parser/model/page_template_builder'
    autoload :TextBlock, 'conditioned_parser/model/text_block'
    autoload :Word, 'conditioned_parser/model/word'
  end

  # query interpretation and evaluation
  module QueryEngine
    autoload :Condition, 'conditioned_parser/query_engine/condition'
    autoload :Query, 'conditioned_parser/query_engine/query'
    autoload :QueryParser, 'conditioned_parser/query_engine/query_parser'
    autoload :Selector, 'conditioned_parser/query_engine/selector'
    autoload :TextMatchCondition, 'conditioned_parser/query_engine/text_match_condition'
  end

  def self.load_document(dev_mode, raw_data, &block)
    # TODO: Remove dev mode flag
    Model::ModelBuilder.build_model_data(raw_data, dev_mode, &block)
  end

  def self.with_document(document, &block)
    query_builder = QueryBuilder.new(document)
    query_data = query_builder.instance_eval(&block) if block_given?
    QueryEngine::QueryParser.generate_query(query_data, document)
  end
end
