# frozen_string_literal: true

# RSpec matcher to spec inheritance.
#
# Usage:
#
# RSpec.describe User, type: :model do
#   subject { described_class }
#
#   it { is_expected.to inherit_from ApplicationRecord }
# end

RSpec::Matchers.define :inherit_from do |superclass|
  match { test_subject.ancestors.include? superclass }
  description { "inherit from #{superclass}" }
  failure_message { "expected #{described_class.name} to inherit from #{superclass}" }
  failure_message_when_negated { "expected #{described_class.name} not to inherit from #{superclass}" }

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
