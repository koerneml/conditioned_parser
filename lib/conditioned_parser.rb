require 'conditioned_parser/version'

# Parses a document according to specified conditions
module ConditionedParser
  autoload :Query, 'conditioned_parser/query'

  # document representation
  module Model
    autoload :Box, 'conditioned_parser/model/box'
    autoload :ContentElement, 'conditioned_parser/model/content_element'
    autoload :Document, 'conditioned_parser/model/document'
    autoload :ModelBuilder, 'conditioned_parser/model/model_builder'
    autoload :Page, 'conditioned_parser/model/page'
    autoload :PageTemplateBuilder, 'conditioned_parser/model/page_template_builder'
    autoload :Word, 'conditioned_parser/model/word'
  end
end
