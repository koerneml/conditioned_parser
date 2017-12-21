require 'nori'

RSpec.describe ConditionedParser do
  it 'has a version number' do
    expect(ConditionedParser::VERSION).not_to be nil
  end

  let(:raw_data) { Nori.new(advanced_typecasting: false).parse(File.read(File.expand_path('files/receiver/read_receiver8.xml', File.dirname(__FILE__)))) }
  let(:query_font_size) {}
  let(:query_page) { 1 }
  let(:query_item) { :name }
  let(:query_pattern) { /Testos Teron/ }
  let(:query_region) {}
  let(:with_template_definition?) { false }

  subject do
    ConditionedParser.with_document raw_data do
      template = nil
      if with_template_definition?
        template = define_template do
          define_region :address do
            starts_at_point(55.0, 80.0)
            ends_at_point(180.0, 140.0)
          end
          define_region :somewhere_else do
            starts_at_point(0.0, 0.0)
            ends_at_point(20.0, 50.0)
          end
        end
      end
      query = define_query do
        page query_page
        with_template template if with_template_definition?
        region query_region if with_template_definition?
        font_size query_font_size unless query_font_size.nil?
        as_text_lines
        search_item_name query_item
        pattern query_pattern
      end
      query
    end
  end

  context 'when querying ACTUAL documents' do
    it 'finds a simple string in the document' do
      expect(subject.result?).to be true
    end

    context 'without a result' do
      let(:query_pattern) { /YOLO!!/ }

      it 'does not find non-matching strings' do
        expect(subject.result?).to be false
      end
    end

    context 'with template definition and usage' do
      let(:with_template_definition?) { true }
      let(:query_region) { :address }
      let(:query_item) { :postal }
      let(:query_pattern) { /\A\d{5}/ }

      it 'looks up specific stuff in previously defined regions' do
        expect(subject.result?).to be true
      end

      context 'when the pattern is in a different region' do
        let(:query_region) { :somewhere_else }

        it 'does not find the string in a region where it is not' do
          expect(subject.result?).to be false
        end
      end

      context 'with allowed font size in range' do
        let(:query_font_size) { 10.0..15.0 }

        it 'filters per font size - in range' do
          expect(subject.result?).to be true
        end
      end

      context 'with allowed font size out of range' do
        let(:query_font_size) { 15.0..20.0 }

        it 'filters per font size - out of range' do
          expect(subject.result?).to be false
        end
      end

      context 'when chaining conditions' do
        it 'allows chaining conditions with and - true - true' do
          good_query = nil
          other_good_query = nil
          ConditionedParser.with_document raw_data do
            good_query = define_query do
              page 1
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
            good_query = define_query do
              page 1
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
    end

    context 'when defining templates' do
      it 'defines templates by absolute coordinates' do
        ConditionedParser.with_document raw_data do
          define_template do
            define_region :address do
              starts_at_point(25, 30)
              ends_at_point(50, 70)
            end
          end
        end
      end

      it 'defines templates by starting point and box data' do
        ConditionedParser.with_document raw_data do
          define_template do
            define_region :address do
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
