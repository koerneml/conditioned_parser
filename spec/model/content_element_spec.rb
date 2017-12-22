RSpec.describe ConditionedParser::Model::ContentElement do

  dummy_box = {
    x_start: 0.0,
    x_end: 20.0,
    y_start: 0.0,
    y_end: 20.0
  }

  words = []
  4.times do |num|
    words << ConditionedParser::Model::Word.new(dummy_box, "word#{num}")
  end

  let(:content) { ConditionedParser::Model::Page.new(dummy_box, 1, words) }

  context 'when matching against its contents' do
    context 'with basic words' do
      context 'which are not contained' do
        it 'detects that there are no matches' do
          expect(content.matches?(/NotHere/)).to be false
        end

        it 'does not return a match' do
          expect(content.match(/NotHere/).empty?).to be true
        end
      end

      context 'which are contained' do
        it 'detects that there is a match' do
          expect(content.matches?(/word0/)).to be true
        end

        it 'returns the match' do
          expect(content.match(/word0/)).to eq ['word0']
        end
      end

      context 'which are contained multiple times' do
        it 'detects that there is a match' do
          expect(content.matches?(/word/)).to be true
        end

        it 'returns the match' do
          expect(content.match(/word/)).to eq ['word']
        end
      end
    end

    context 'with longer structures' do
      lines = []
      4.times do
        lines << ConditionedParser::Model::Line.new(dummy_box, words)
      end
      let(:content) { ConditionedParser::Model::Page.new(dummy_box, 1, lines) }

      context 'which are not contained' do
        it 'detects that there are no matches' do
          expect(content.matches?(/lalala/)).to be false
        end

        it 'does not return a match' do
          expect(content.match(/lalala/).empty?).to be true
        end
      end

      context 'which are contained' do
        it 'detects that there is a match' do
          expect(content.matches?(/word0 word1/)).to be true
        end

        it 'returns the match' do
          expect(content.match(/word0 word1/)).to eq ['word0 word1']
        end
      end
    end
  end
end
