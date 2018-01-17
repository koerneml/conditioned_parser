require_relative 'model/document_input_processor'

module ConditionedParser
  # Builds the document from raw data. Currently only supports nori-parsed pdftotext output.
  module DocumentGenerator
    def self.build_document(raw_data)
      Model::DocumentInputProcessor.build_document(raw_data)
    end
  end
end
