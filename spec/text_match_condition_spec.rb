require 'spec_helper'

RSpec.describe ConditionedParser::TextMatchCondition do
  let(:simple_string) { 'Hello World' }
  let(:matching_pattern) { /ello/ }
  let(:non_matching_pattern) { /tabaluga/ }

  it 'matches a basic String to a trivial pattern' do
    condition = ConditionedParser::TextMatchCondition.new
    condition.item = simple_string
    condition.pattern = matching_pattern
    expect(condition.matches?).to be true
  end

  it 'does not match non-matching strings' do
    condition = ConditionedParser::TextMatchCondition.new
    condition.item = simple_string
    condition.pattern = non_matching_pattern
    expect(condition.matches?).to be false
  end

  context 'when conditions are chaining' do
    let(:other_string) { 'la-di-dah' }
    let(:other_matching_pattern) { /dah/ }

    it 'chains conditions with and' do
      condition_a = ConditionedParser::TextMatchCondition.new
      condition_a.item = simple_string
      condition_a.pattern = matching_pattern
      condition_b = ConditionedParser::TextMatchCondition.new
      condition_b.item = other_string
      condition_b.pattern = other_matching_pattern
      expect(condition_a.and(condition_b)).to be true
    end
  end
end
