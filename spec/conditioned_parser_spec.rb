RSpec.describe ConditionedParser do
  it 'has a version number' do
    expect(ConditionedParser::VERSION).not_to be nil
  end

  sample_words = [
    {
      x_start: 0,
      x_end: 12,
      y_start: 0,
      y_end: 12,
      text: 'Yolo'
    },
    {
      x_start: 15,
      x_end: 30,
      y_start: 0,
      y_end: 12,
      text: 'lalala'
    }
  ]

  more_word_samples = [
    {
      x_start: 0,
      x_end: 12,
      y_start: 0,
      y_end: 12,
      text: 'DRY'
    },
    {
      x_start: 15,
      x_end: 30,
      y_start: 0,
      y_end: 12,
      text: 'pupiduh'
    }
  ]

  sample_page1 = {
    page_no: 1,
    width: 256,
    height: 400,
    words: sample_words
  }

  sample_page2 = {
    page_no: 2,
    width: 256,
    height: 500,
    words: more_word_samples
  }

  context 'when parsing document data' do
    let(:raw_data) { { document: { pages: [sample_page1, sample_page2] } } }

    it 'performs a simple text match' do
      document = ConditionedParser.load_document(raw_data)
      query = ConditionedParser.with_document document do
        there_is_text do
          matching_a_pattern(/Yolo/)
        end
      end
      expect(query.result?).to be true
    end

    it 'does not match when there is no match' do
      document = ConditionedParser.load_document(raw_data)
      query = ConditionedParser.with_document document do
        there_is_text do
          matching_a_pattern(/Swag/)
        end
      end
      expect(query.result?).to be false
    end

    context 'and looking for a specific page' do
      it 'finds the pattern on the specified page' do
        document = ConditionedParser.load_document(raw_data)
        query = ConditionedParser.with_document document do
          on_page 2
          there_is_text do
            matching_a_pattern(/pupiduh/)
          end
        end
        expect(query.result?).to be true
      end

      it 'finds the pattern given a page range' do
        document = ConditionedParser.load_document(raw_data)
        query = ConditionedParser.with_document document do
          on_page 1..2
          there_is_text do
            matching_a_pattern(/pupiduh/)
          end
        end
        expect(query.result?).to be true
      end

      it 'does not find the pattern if another page is specified' do
        document = ConditionedParser.load_document(raw_data)
        query = ConditionedParser.with_document document do
          on_page 1
          there_is_text do
            matching_a_pattern(/pupiduh/)
          end
        end
        expect(query.result?).to be false
      end

      it 'also does not find pattern if not in range' do
        document = ConditionedParser.load_document(raw_data)
        query = ConditionedParser.with_document document do
          on_page 1..1
          there_is_text do
            matching_a_pattern(/pupiduh/)
          end
        end
        expect(query.result?).to be false
      end
    end
  end
end
