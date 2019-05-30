# frozen_string_literal: true

# RSpec matcher that tests usage of `.allow_keys`
#
#     class Example < RedisHash
#       allow_keys :foo, :bar
#     end
#
#     RSpec.describe Example, type: :redis_hash do
#       subject { described_class }
#
#       it { is_expected.to allow_key :foo }
#       it { is_expected.to allow_key :bar }
#     end

RSpec::Matchers.define :allow_key do |key|
  match { expect(test_subject._allowed_keys).to include key }
  description { "allow key #{key}" }
  failure_message { "expected #{test_subject} to allow key #{key}" }

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
