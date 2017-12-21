require 'conditioned_parser/version'

# Parses a document according to specified conditions
module ConditionedParser
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

  class << self
    def with_document(raw_data, &block)
      @document = Model::DocumentInputProcessor.build_document(raw_data)
      instance_eval(&block) if block_given?
    end

    def define_template(&block)
      Template.new.tap { |t| t.instance_eval(&block) if block_given? }
    end

    def define_query(&block)
      Query.new(@document).tap { |q| q.instance_eval(&block) if block_given? }
    end
  end
end
