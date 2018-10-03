# frozen_string_literal: true

# RSpec matcher for include module.
#
# Usage:
#
# RSpec.describe User, type: :model do
#   subject { described_class }
#
#   it { is_expected.to include_module ApplicationRecord }
# end

RSpec::Matchers.define :include_module do |module_class|
  match do
    test_subject.included_modules.include? module_class
  end

  description do
    "included the module #{module_class}"
  end

  failure_message do |described_class|
    "expected #{described_class} to include module #{module_class}"
  end

  failure_message_when_negated do |described_class|
    "expected #{described_class} not to include module #{module_class}"
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
