require 'conditioned_parser/version'
require 'conditioned_parser/execution'

# Parses a document according to specified conditions
module ConditionedParser
  extend Execution

  autoload :FallbackContextProxy, 'conditioned_parser/fallback_context_proxy'
  autoload :Query, 'conditioned_parser/query'
  autoload :Filter, 'conditioned_parser/filter'
  autoload :Matcher, 'conditioned_parser/matcher'
  autoload :Region, 'conditioned_parser/region'
  autoload :Template, 'conditioned_parser/template'

  # document representation
  module Model
    autoload :Box, 'conditioned_parser/model/box'
    autoload :ContentElement, 'conditioned_parser/model/content_element'
    autoload :Document, 'conditioned_parser/model/document'
    autoload :DocumentInputProcessor, 'conditioned_parser/model/document_input_processor'
    autoload :Line, 'conditioned_parser/model/line'
    autoload :ModelBuilder, 'conditioned_parser/model/model_builder'
    autoload :Page, 'conditioned_parser/model/page'
    autoload :TextBox, 'conditioned_parser/model/text_box'
    autoload :Word, 'conditioned_parser/model/word'
  end

  def with_document(raw_data, *args, &block)
    raise 'Block required for document operations' unless block_given?
    @document = Model::DocumentInputProcessor.build_document(raw_data)
    exec_in_proxy_context(self, FallbackContextProxy, *args, &block)
  end
  module_function :with_document

  def define_template(*args, &block)
    raise 'Block required for template definition!' unless block_given?
    Template.new.tap { |t| exec_in_proxy_context(t, FallbackContextProxy, *args, &block) }
  end
  module_function :define_template

  def define_query(*args, &block)
    raise 'Block required for query definition!' unless block_given?
    Query.new(@document).tap { |q| exec_in_proxy_context(q, FallbackContextProxy, *args, &block) }
  end
  module_function :define_query
end
