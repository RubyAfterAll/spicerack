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
  match do
    described_class.ancestors.include? superclass
  end

  description do
    "inherit from #{superclass}"
  end

  failure_message do
    "expected #{described_class.name} to inherit from #{superclass}"
  end

  failure_message_when_negated do
    "expected #{described_class.name} not to inherit from #{superclass}"
  end
end
