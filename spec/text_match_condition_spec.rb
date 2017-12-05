require 'spec_helper'

RSpec.describe ConditionedParser::TextMatchCondition do
  let(:simple_word) { ConditionedParser::Model::Word.new(0, 0, 0, 0, 'Hello') }
  let(:matching_pattern) { /ello/ }
  let(:non_matching_pattern) { /tabaluga/ }

  it 'matches a basic String to a trivial pattern' do
    condition = ConditionedParser::TextMatchCondition.new(simple_word, matching_pattern)
    expect(condition.matches?).to be true
  end

  it 'does not match non-matching strings' do
    condition = ConditionedParser::TextMatchCondition.new(simple_word, non_matching_pattern)
    expect(condition.matches?).to be false
  end

  context 'when conditions are chaining' do
    let(:other_word) { ConditionedParser::Model::Word.new(0, 0, 0, 0, 'ladidah') }
    let(:other_matching_pattern) { /dah/ }

    it 'chains conditions with and' do
      condition_a = ConditionedParser::TextMatchCondition.new(simple_word, matching_pattern)
      condition_b = ConditionedParser::TextMatchCondition.new(other_word, other_matching_pattern)
      expect(condition_a.and(condition_b)).to be true
    end
  end
end
