RSpec.describe ConditionedParser::Model::Box do
  box_data1 = {
    x_start: 0.0,
    x_end: 20.0,
    y_start: 0.0,
    y_end: 20.0
  }

  context 'a single box' do
    let(:box) { ConditionedParser::Model::Word.new(box_data1, 'IAmABox') }

    it 'correctly gives its height' do
      expect(box.height).to be 20.0
    end

    it 'correctly gives its width' do
      expect(box.width).to be 20.0
    end
  end

  context 'when comparing two boxes' do
    box_data2 = {
      x_start: 0.0,
      x_end: 10.0,
      y_start: 0.0,
      y_end: 10.0
    }

    context 'and box 1 contains box 2' do
      let(:outer_box) { ConditionedParser::Model::Word.new(box_data1, 'IAmABox') }
      let(:inner_box) { ConditionedParser::Model::Word.new(box_data2, 'IAmAlsoABox') }

      it 'detects that box 1 contains box 2' do
        expect(outer_box.contains?(inner_box)).to be true
      end

      it 'detects that box 2 is contained in box 1' do
        expect(inner_box.contained_in?(outer_box)).to be true
      end
    end

    context 'exactly on the same line' do
      let(:box) { ConditionedParser::Model::Word.new(box_data1, 'Box') }

      same_line_box_data = {
        x_start: 22.0,
        x_end: 28.0,
        y_start: 0.0,
        y_end: 20.0
      }
      let(:same_line_box) { ConditionedParser::Model::Word.new(same_line_box_data, 'box') }

      it 'detects boxes on the same line' do
        expect(box.on_same_line?(same_line_box)).to be true
      end
    end

    context 'on the same line within tolerance' do
      let(:box) { ConditionedParser::Model::Word.new(box_data1, 'box') }

      within_def_tolerance_data = {
        x_start: 22.0,
        x_end: 28.0,
        y_start: 0.4,
        y_end: 21.9
      }

      let(:tolerance_box) { ConditionedParser::Model::Word.new(within_def_tolerance_data, 'box') }

      it 'detects boxes on the same line' do
        expect(box.on_same_line?(tolerance_box)).to be true
      end
    end

    context 'not on the same line' do
      let(:box) { ConditionedParser::Model::Word.new(box_data1, 'box') }

      out_of_tolerance_data = {
        x_start: 22.0,
        x_end: 28.0,
        y_start: 0.6,
        y_end: 23.0
      }

      let(:tolerance_box) { ConditionedParser::Model::Word.new(out_of_tolerance_data, 'box') }

      it 'detects that boxes are not on the same line' do
        expect(box.on_same_line?(tolerance_box)).to be false
      end

      context 'with adapted tolerance values' do
        tolerance_opts = {
          y_tolerance: 0.7,
          height_tolerance: 4.0
        }

        it 'detects the boxes as being on the same line' do
          expect(box.on_same_line?(tolerance_box, tolerance_opts)).to be true
        end
      end
    end
  end
end
