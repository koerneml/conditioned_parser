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
          search_item_name :type
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
          search_item_name :type
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
          search_item_name :postal
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
          search_item_name :postal
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
      expect(text_lines.last.matches?(/^\d{5}/)).to be true
    end

    context 'when chaining conditions' do
      it 'allows chaining conditions with and - true - true' do
        good_query = nil
        other_good_query = nil
        ConditionedParser.with_document raw_data do
          good_query = define_query do
            page 1
            with_template [address_region, somewhere_else]
            region :address
            as_text_lines
            search_item_name :postal
            pattern(/^\d{5}/)
          end
          other_good_query = define_query do
            page 1
            search_item_name :type
            pattern(/Rechnung/)
          end
        end
        expect(good_query.result? && other_good_query.result?).to be true
      end

      it 'allows chaining conditions with and - true - false' do
        good_query = nil
        bad_query = nil
        ConditionedParser.with_document raw_data do
          good_query = define_query do
            page 1
            with_template [address_region, somewhere_else]
            region :address
            search_item_name :postal
            pattern(/^\d{5}/)
          end
          bad_query = define_query do
            pages 1..2
            as_text_lines
            search_item_name :bs
            pattern(/YOLO/)
          end
        end
        expect(good_query.result? && bad_query.result?).to be false
        expect(good_query.result? || bad_query.result?).to be true
      end
    end
  end
end
