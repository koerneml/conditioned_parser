RSpec.describe ConditionedParser::Model::Word do
  box_for_word = {
    x_start: 0.0,
    x_end: 20.0,
    y_start: 0.0,
    y_end: 20.0
  }

  let(:word) { ConditionedParser::Model::Word.new(box_for_word, 'bird') }

  it 'gives its contained text' do
    expect(word.contained_text).to eq 'bird'
  end
end
