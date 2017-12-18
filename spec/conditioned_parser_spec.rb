require 'nori'

RSpec.describe ConditionedParser do
  it 'has a version number' do
    expect(ConditionedParser::VERSION).not_to be nil
  end

  context 'when parsing ACTUAL documents' do
    let(:raw_data) { Nori.new(advanced_typecasting: false).parse(File.read(File.expand_path('files/real_life_test.xml', File.dirname(__FILE__)))) }

    it 'finds a simple string in the document' do
      query = nil
      ConditionedParser.with_document raw_data do
        query = define_query do
          page 1
          search_item :type
          pattern(/Rechnung/)
        end
      end
      puts query.result
      expect(query.result?).to be true
    end

    it 'does not find non-matching strings' do
      query = nil
      ConditionedParser.with_document raw_data do
        query = define_query do
          page 1
          search_item :type
          pattern(/YOLO!!/)
        end
      end
      puts query.result
      expect(query.result?).to be false
    end

    address_region = {
      identifier: :address,
      x_start: 70.0,
      x_end: 200.0,
      y_start: 160.0,
      y_end: 235.0
    }
    somewhere_else = {
      identifier: :somewhere,
      x_start: 0.0,
      x_end: 20.0,
      y_start: 0.0,
      y_end: 50.0
    }

    it 'looks up specific stuff in previously defined regions' do
      query = nil
      ConditionedParser.with_document raw_data do
        query = define_query do
          page 1
          with_template [address_region, somewhere_else]
          region :address
          as_text_lines
          search_item :postal
          pattern(/^\d{5}/)
        end
      end
      puts query.result
      expect(query.result?).to be true
    end

    it 'does not find the string in a region where it is not' do
      query = nil
      ConditionedParser.with_document raw_data do
        query = define_query do
          page 1
          with_template [address_region, somewhere_else]
          region :somewhere
          search_item :postal
          pattern(/^\d{5}/)
        end
      end
      puts query.result
      expect(query.result?).to be false
    end

    it 'allows for custom manipulation of text lines' do
      query = nil
      text_lines = nil
      ConditionedParser.with_document raw_data do
        query = define_query do
          page 1
          with_template [address_region, somewhere_else]
          region :address
          text_lines = as_text_lines
        end
      end
      puts 'hello'
      puts text_lines.inspect
    end
  end
end
