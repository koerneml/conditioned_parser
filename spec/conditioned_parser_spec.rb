require 'nori'

RSpec.describe ConditionedParser do
  it 'has a version number' do
    expect(ConditionedParser::VERSION).not_to be nil
  end

  context 'when parsing ACTUAL documents' do
    let(:raw_data) { Nori.new(advanced_typecasting: false).parse(File.read(File.expand_path('files/receiver/read_receiver8.xml', File.dirname(__FILE__)))) }

    it 'finds a simple string in the document' do
      query = nil
      ConditionedParser.with_document raw_data do
        query = define_query do
          page 1
          as_text_lines
          search_item_name :name
          pattern(/Testos Teron/)
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

    it 'looks up specific stuff in previously defined regions' do
      query = nil
      ConditionedParser.with_document raw_data do
        template = define_template do
          region :address do
            starts_at_point(55.0, 80.0)
            ends_at_point(180.0, 140.0)
          end
          region :somewhere_else do
            starts_at_point(0.0, 0.0)
            ends_at_point(20.0, 50.0)
          end
        end
        query = define_query do
          page 1
          with_template template
          region :address
          as_text_lines
          search_item_name :postal
          pattern(/\A\d{5}/)
        end
      end
      expect(query.result?).to be true
    end

    it 'does not find the string in a region where it is not' do
      query = nil
      ConditionedParser.with_document raw_data do
        template = define_template do
          region :address do
            starts_at_point(55.0, 80.0)
            ends_at_point(180.0, 140.0)
          end
          region :somewhere_else do
            starts_at_point(0.0, 0.0)
            ends_at_point(20.0, 50.0)
          end
        end
        query = define_query do
          page 1
          with_template template
          region :somewhere_else
          search_item_name :postal
          pattern(/\A\d{5}/)
        end
      end
      puts query.result
      expect(query.result?).to be false
    end

    it 'allows for custom manipulation of text lines' do
      query = nil
      text_lines = nil
      ConditionedParser.with_document raw_data do
        template = define_template do
          region :address do
            starts_at_point(55.0, 80.0)
            ends_at_point(180.0, 140.0)
          end
          region :somewhere_else do
            starts_at_point(0.0, 0.0)
            ends_at_point(20.0, 50.0)
          end
        end
        query = define_query do
          page 1
          with_template template
          region :address
          text_lines = as_text_lines
        end
      end
      expect(text_lines.last.matches?(/\A\d{5}/)).to be true
    end

    it 'filters per font size - in range' do
      query = nil
      ConditionedParser.with_document raw_data do
        template = define_template do
          region :address do
            starts_at_point(55.0, 80.0)
            ends_at_point(180.0, 140.0)
          end
          region :somewhere_else do
            starts_at_point(0.0, 0.0)
            ends_at_point(20.0, 50.0)
          end
        end
        query = define_query do
          page 1
          with_template template
          region :address
          font_size 10.0..15.0
          as_text_lines
          search_item_name :postal
          pattern(/\A\d{5}/)
        end
      end
      expect(query.result?).to be true
    end

    it 'filters per font size - out of range' do
      query = nil
      ConditionedParser.with_document raw_data do
        template = define_template do
          region :address do
            starts_at_point(55.0, 80.0)
            ends_at_point(180.0, 140.0)
          end
          region :somewhere_else do
            starts_at_point(0.0, 0.0)
            ends_at_point(20.0, 50.0)
          end
        end
        query = define_query do
          page 1
          with_template template
          region :address
          font_size 15.0..20.0
          as_text_lines
          search_item_name :postal
          pattern(/\A\d{5}/)
        end
      end
      expect(query.result?).to be false
    end

    context 'when chaining conditions' do
      it 'allows chaining conditions with and - true - true' do
        good_query = nil
        other_good_query = nil
        ConditionedParser.with_document raw_data do
          template = define_template do
            region :address do
              starts_at_point(55.0, 80.0)
              ends_at_point(180.0, 140.0)
            end
            region :somewhere_else do
              starts_at_point(0.0, 0.0)
              ends_at_point(20.0, 50.0)
            end
          end
          good_query = define_query do
            page 1
            with_template template
            region :address
            as_text_lines
            search_item_name :postal
            pattern(/\A\d{5}/)
          end
          other_good_query = define_query do
            page 1
            as_text_lines
            search_item_name :name
            pattern(/Testos Teron/)
          end
        end
        expect(good_query.result? && other_good_query.result?).to be true
      end

      it 'allows chaining conditions with and - true - false' do
        good_query = nil
        bad_query = nil
        ConditionedParser.with_document raw_data do
          template = define_template do
            region :address do
              starts_at_point(55.0, 80.0)
              ends_at_point(180.0, 140.0)
            end
            region :somewhere_else do
              starts_at_point(0.0, 0.0)
              ends_at_point(20.0, 50.0)
            end
          end
          good_query = define_query do
            page 1
            with_template template
            region :address
            search_item_name :postal
            pattern(/\A\d{5}/)
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

    context 'when defining templates' do
      it 'defines templates by absolute coordinates' do
        ConditionedParser.with_document raw_data do
          define_template do
            region :address do
              starts_at_point(25, 30)
              ends_at_point(50, 70)
            end
          end
        end
      end

      it 'defines templates by starting point and box data' do
        ConditionedParser.with_document raw_data do
          define_template do
            region :address do
              starts_at_point(25, 30)
              has_width 50
              has_height 200
            end
          end
        end
      end
    end
  end
end
