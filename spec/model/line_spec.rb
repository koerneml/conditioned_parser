RSpec.describe ConditionedParser::Model::Line do
  box0 = {
    x_start: 0.0,
    x_end: 8.0,
    y_start: 0.0,
    y_end: 10.0
  }
  box1 = {
    x_start: 10.0,
    x_end: 18.0,
    y_start: 0.0,
    y_end: 10.0
  }
  box2 = {
    x_start: 24.0,
    x_end: 28.0,
    y_start: 0.0,
    y_end: 10.0
  }
  box3 = {
    x_start: 30.0,
    x_end: 38.0,
    y_start: 0.0,
    y_end: 10.0
  }
  line_box = {
    x_start: 0.0,
    x_end: 38.0,
    y_start: 0.0,
    y_end: 10.0
  }

  line_words = []
  line_words << ConditionedParser::Model::Word.new(box0, 'first')
  line_words << ConditionedParser::Model::Word.new(box1, 'second')
  line_words << ConditionedParser::Model::Word.new(box2, 'third')
  line_words << ConditionedParser::Model::Word.new(box3, 'fourth')

  let(:line) { ConditionedParser::Model::Line.new(line_box, line_words) }

  context 'when returning its contained text' do
    it 'correctly gives its contained text' do
      expect(line.contained_text).to eq "first second third fourth\n"
    end

    it 'gives its text with spacing' do
      expect(line.contained_text_with_spacing(2.0)).to eq "first second   third fourth\n"
    end
  end

  context 'when splitting up lines' do
    let(:unsplit_line) { ConditionedParser::Model::Line.new(line_box, line_words) }

    it 'splits all words when x_distance is low' do
      split_lines = unsplit_line.split_by_x_distance(1.0)
      expect(split_lines.size).to eq(4)
      expect(split_lines[0].contained_text).to eq "first\n"
      expect(split_lines[1].contained_text).to eq "second\n"
      expect(split_lines[2].contained_text).to eq "third\n"
      expect(split_lines[3].contained_text).to eq "fourth\n"
    end

    it 'splits big distances when x_distance is medium' do
      split_lines = unsplit_line.split_by_x_distance(5.0)
      expect(split_lines.size).to eq(2)
      expect(split_lines[0].contained_text).to eq "first second\n"
      expect(split_lines[1].contained_text).to eq "third fourth\n"
    end

    it 'does not split when x_distance is high' do
      split_lines = unsplit_line.split_by_x_distance(10.0)
      expect(split_lines.size).to eq(1)
      expect(split_lines[0].contained_text).to eq "first second third fourth\n"
    end
  end
end
