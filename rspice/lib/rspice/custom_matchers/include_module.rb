# frozen_string_literal: true

# RSpec matcher that tests usages of [Module#include](https://apidock.com/ruby/Module/include)
#
#     module Nodule; end
#     class Klass
#       include Nodule
#     end
#
#     RSpec.describe Klass do
#       it { is_expected.to include_module Nodule }
#     end

RSpec::Matchers.define :include_module do |module_class|
  match { test_subject.included_modules.include? module_class }
  description { "included the module #{module_class}" }
  failure_message { |described_class| "expected #{described_class} to include module #{module_class}" }
  failure_message_when_negated { |described_class| "expected #{described_class} not to include module #{module_class}" }

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
