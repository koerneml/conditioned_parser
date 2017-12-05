RSpec.describe ConditionedParser do
  it 'has a version number' do
    expect(ConditionedParser::VERSION).not_to be nil
  end

  context 'when parsing document data' do
    let(:raw_data) {{ document: { pages: [{ page_no: 1, width: 256, height: 400, words: [{ x_start: 0, x_end: 12, y_start: 0, y_end: 12, text: 'Yolo' }] }] } }}

    it 'performs a simple text match' do
      document = ConditionedParser.load_document(raw_data)
      condition = ConditionedParser.with_document document do
        there_is_text do
          matching_a_pattern(/Yolo/)
        end
      end
      expect(condition.matches?).to be true
    end
  end
end
