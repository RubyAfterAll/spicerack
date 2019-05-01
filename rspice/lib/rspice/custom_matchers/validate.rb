# frozen_string_literal: true

# RSpec matcher that tests application of a custom validator to a spefific attribute
#
#   describe User do
#     # With no options:
#     it { is_expected.to validate(:an_attribute).with(CustomValidator) }
#
#     # With options:
#     it { is_expected.to validate(:an_attribute).with(CustomValidator).with_options(aliased_as: :a_property) }
#   end

RSpec::Matchers.define :validate do |attribute|
  match do |subject|
    raise Rspice::IncompleteMatcherError, "validator class not provided" unless @expected_validator.present?

    @validator = subject.class.validators.find do |validator|
      next unless validator.respond_to?(:attributes)

      validator.attributes.include?(attribute.to_sym) && validator.class == @expected_validator
    end

    @validator.present? && options_matching?
  end

  def options_matching?
    if @options.present?
      @options.keys.all? { |option| @validator.options[option] == @options[option] }
    else
      true
    end
  end

  chain :with do |validator|
    @expected_validator = validator
  end

  chain :with_options do |options|
    @options = options
  end

  description do
    "validate with #{@validator.class}#{" with options #{@options}" if @options.present?}"
  end

  failure_message do
    "expected to validate #{attribute} with #{@expected_validator}#{" with options #{@options}" if @options.present?}"
  end

  failure_message_when_negated do
    "not expected to validate #{attribute} with #{@expected_validator}#{" with options #{@options}" if @options.present?}"
  end
end
