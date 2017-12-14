require 'nori'

RSpec.describe ConditionedParser do
  it 'has a version number' do
    expect(ConditionedParser::VERSION).not_to be nil
  end

  context 'when parsing ACTUAL documents' do
    let(:raw_data) { Nori.new(advanced_typecasting: false).parse(File.read(File.expand_path('files/real_life_test.xml', File.dirname(__FILE__)))) }

    it 'finds a simple string in the document' do
      ConditionedParser.with_document raw_data do
        query = define_query do
          page 1 do
            search_item :type
            pattern(/Rechnung/)
          end
        end
        puts query.result
        expect(query.result?).to be true
      end
    end

    it 'does not find non-matching strings' do
      ConditionedParser.with_document raw_data do
        query = define_query do
          page 1 do
            search_item :type
            pattern(/YOLO!!/)
          end
        end
        puts query.result
        expect(query.result?).to be false
      end
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
      ConditionedParser.with_document raw_data do
        query = define_query do
          page 1 do
            with_template [address_region, somewhere_else] do
              region :address do
                as_text_lines do
                  search_item :postal
                  pattern(/^\d{5}/)
                end
              end
            end
          end
        end
        puts query.result
        expect(query.result?).to be true
      end
    end

    it 'does not find the string in a region where it is not' do
      ConditionedParser.with_document raw_data do
        query = define_query do
          page 1 do
            with_template [address_region, somewhere_else] do
              region :somewhere do
                as_text_lines do |line|
                  search_item :postal
                  pattern(/^\d{5}/)
                end
              end
            end
          end
        end
        puts query.result
        expect(query.result?).to be false
      end
    end
  end
end
