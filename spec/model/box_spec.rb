RSpec.describe ConditionedParser::Model::Box do
  box_data1 = {
    x_start: 0.0,
    x_end: 20.0,
    y_start: 0.0,
    y_end: 20.0
  }

  let(:box1) { ConditionedParser::Model::Word.new(box_data1, 'IAmABox') }

  context 'a single box' do
    it 'correctly gives its height' do
      expect(box1.height).to be 20.0
    end

    it 'correctly gives its width' do
      expect(box1.width).to be 20.0
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
      let(:box2) { ConditionedParser::Model::Word.new(box_data2, 'IAmAlsoABox') }

      it 'detects that box 1 contains box 2' do
        expect(box1.contains?(box2)).to be true
      end

      it 'detects that box 2 is contained in box 1' do
        expect(box2.contained_in?(box1)).to be true
      end

      it 'detects that box1 overlaps box 2' do
        expect(box1.overlap?(box2)).to be true
      end

      it 'detects that box2 overlaps box 1' do
        expect(box2.overlap?(box1)).to be true
      end
    end

    context 'exactly on the same line' do
      same_line_box_data = {
        x_start: 22.0,
        x_end: 28.0,
        y_start: 0.0,
        y_end: 20.0
      }
      let(:same_line_box) { ConditionedParser::Model::Word.new(same_line_box_data, 'box') }

      it 'detects boxes on the same line' do
        expect(box1.on_same_line?(same_line_box)).to be true
      end
    end

    context 'on the same line within tolerance' do
      within_def_tolerance_data = {
        x_start: 22.0,
        x_end: 28.0,
        y_start: 0.4,
        y_end: 21.9
      }

      let(:tolerance_box) { ConditionedParser::Model::Word.new(within_def_tolerance_data, 'box') }

      it 'detects boxes on the same line' do
        expect(box1.on_same_line?(tolerance_box)).to be true
      end
    end

    context 'not on the same line' do
      out_of_tolerance_data = {
        x_start: 22.0,
        x_end: 28.0,
        y_start: 0.6,
        y_end: 23.0
      }

      let(:tolerance_box) { ConditionedParser::Model::Word.new(out_of_tolerance_data, 'box') }

      it 'detects that boxes are not on the same line' do
        expect(box1.on_same_line?(tolerance_box)).to be false
      end

      context 'with adapted tolerance values' do
        tolerance_opts = {
          y_tolerance: 0.7,
          height_tolerance: 4.0
        }

        it 'detects the boxes as being on the same line' do
          expect(box1.on_same_line?(tolerance_box, tolerance_opts)).to be true
        end
      end
    end

    context 'and comparing placement of boxes' do
      right_box_data = {
        x_start: 22.0,
        x_end: 30.0,
        y_start: 0.0,
        y_end: 20.0
      }
      let(:left_box) { ConditionedParser::Model::Word.new(box_data1, 'left') }
      let(:right_box) { ConditionedParser::Model::Word.new(right_box_data, 'right') }

      it 'detects that the left box is left of the right box' do
        expect(left_box.left_of?(right_box)).to be true
      end

      it 'detects that the right box is right of the left box' do
        expect(right_box.right_of?(left_box)).to be true
      end

      context 'when boxes are overlapping' do
        context 'with x and y overlap' do
          overlap_box_data = {
            x_start: 15.0,
            x_end: 25.0,
            y_start: 12.0,
            y_end: 25.0
          }
          let(:overlap_box) { ConditionedParser::Model::Word.new(overlap_box_data, 'overlap') }

          it 'detects that box 1 overlaps box 2' do
            expect(box1.overlap?(overlap_box)).to be true
          end

          it 'detects that box 2 overlaps box 1' do
            expect(overlap_box.overlap?(box1)).to be true
          end
        end

        context 'x overlap only' do
          overlap_box_data = {
            x_start: 15.0,
            x_end: 25.0,
            y_start: 40.0,
            y_end: 80.0
          }
          let(:overlap_box) { ConditionedParser::Model::Word.new(overlap_box_data, 'noREALoverlap') }

          it 'detects that box 1 does not overlap box 2' do
            expect(box1.overlap?(overlap_box)).to be false
          end

          it 'detects that box 2 does not overlap box 1' do
            expect(overlap_box.overlap?(box1)).to be false
          end
        end

        context 'y overlap only' do
          overlap_box_data = {
            x_start: 30.0,
            x_end: 50.0,
            y_start: 5.0,
            y_end: 25.0
          }
          let(:overlap_box) { ConditionedParser::Model::Word.new(overlap_box_data, 'noREALoverlap') }

          it 'detects that box 1 does not overlap box 2' do
            expect(box1.overlap?(overlap_box)).to be false
          end

          it 'detects that box 2 does not overlap box 1' do
            expect(overlap_box.overlap?(box1)).to be false
          end
        end

        context 'no overlap at all' do
          overlap_box_data = {
            x_start: 30.0,
            x_end: 50.0,
            y_start: 40.0,
            y_end: 80.0
          }
          let(:overlap_box) { ConditionedParser::Model::Word.new(overlap_box_data, 'noREALoverlap') }

          it 'detects that box 1 does not overlap box 2' do
            expect(box1.overlap?(overlap_box)).to be false
          end

          it 'detects that box 2 does not overlap box 1' do
            expect(overlap_box.overlap?(box1)).to be false
          end
        end
      end
    end
  end
end
