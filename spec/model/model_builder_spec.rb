RSpec.describe ConditionedParser::Model::ModelBuilder do
  let(:raw_data) { { document: { pages: [{ page_no: 1, width: 256, height: 400, words: [{ x_start: 0, x_end: 12, y_start: 0, y_end: 12, text: 'Yolo' }] }] } } }

  it 'builds a model from raw data' do
    ConditionedParser::Model::ModelBuilder.build_model_data(raw_data)
  end
end
