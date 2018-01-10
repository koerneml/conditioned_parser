RSpec.describe ConditionedParser::Model::Line do
  box_data = {
    x_start: 0.0,
    x_end: 24.0,
    y_start: 0.0,
    y_end: 35.0
  }

  line_words = []
  4.times do |num|
    line_words << ConditionedParser::Model::Word.new(box_data, "word#{num}")
  end
  let(:line) { ConditionedParser::Model::Line.new(box_data, line_words) }

  it 'correctly gives its contained text' do
    expect(line.contained_text).to eq "word0 word1 word2 word3\n"
  end
end
