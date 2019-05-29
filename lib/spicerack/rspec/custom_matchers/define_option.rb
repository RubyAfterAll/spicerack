# frozen_string_literal: true

# RSpec matcher that tests usage of `.option`
#
#     class Example < Spicerack::InputObject
#       option :foo
#       option :bar, default: :baz
#       option(:gaz) { :haz }
#     end
#
#     RSpec.describe Example, type: :input_object do
#       subject { described_class.new(**input) }
#
#       let(:input) { {} }
#
#       it { is_expected.to define_option :foo }
#       it { is_expected.to define_option :bar, default: :baz }
#       it { is_expected.to define_option :gaz, default: :haz }
#     end

RSpec::Matchers.define :define_option do |option, default: nil|
  match do |instance|
    expect(instance._defaults[option]&.value).to eq default
    expect(instance._options).to include option
  end
  description { "define option #{option}" }
  failure_message { "expected #{described_class} to define option #{option} #{for_default(default)}" }

  def for_default(default)
    return "without a default value" if default.nil?

    "with default value #{default}"
  end
end
