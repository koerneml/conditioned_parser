RSpec.describe ConditionedParser do
  it 'has a version number' do
    expect(ConditionedParser::VERSION).not_to be nil
  end

  it 'performs a simple text match' do
    condition = ConditionedParser.with_document ConditionedParser::Document.new do
      # on_page 1
      # in_region :upper_right
      there_should_be_text do
        # over_multiple_lines 3
        # with_font_size min: 15, max: 20
        matching_a_pattern(/dummy/)
      end
    end
    expect(condition.matches?).to be true
  end
end
