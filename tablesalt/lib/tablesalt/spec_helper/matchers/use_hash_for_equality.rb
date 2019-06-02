# frozen_string_literal: true


# Usage:

#     describe AClass do
#       it { is_expected.to use_hash_for_equality }
#     end

RSpec::Matchers.define :use_hash_for_equality do
  match do |subject|
    equal_when_hash_matches(subject)
    inequal_when_hash_doesnt_match(subject)
    aliases_eql(subject)
  end

  chain :with_options do |options|
    @options = options
  end

  description do
    "uses hash for equality"
  end

  failure_message do
    "expected to use hash for equality"
  end

  failure_message_when_negated do
    "not expected to use hash for equality"
  end

  def equal_when_hash_matches(subject)
    other = double
    hash = subject.hash

    allow(other).to receive(:hash).and_return(hash)
    expect(subject).to eq other
  end

  def inequal_when_hash_doesnt_match(subject)
    other = double
    hash = subject.hash

    allow(other).to receive(:hash).and_return(hash + 1)
    expect(subject).not_to eq other
  end

  def aliases_eql(subject)
    expect(subject.class.instance_method(:eql?)).to eq subject.class.instance_method(:==)
  end
end
