# frozen_string_literal: true

# RSpec matcher to test activities.
#
# Usage:
#
# RSpec.describe ApplicationRecord, type: :model do
#   subject { described_class.new }
#
#   before { # put record in invalid statae }
#
#   it { is_expected.to have_error_on_attribute(:foo).with_detail_key(:bar) }
# end

RSpec::Matchers.define :have_error_on_attribute do |attribute|
  match do |record|
    raise ArgumentError, "have_error_on_attribute matcher requires a detail_key" if @detail_key.blank?

    errors = (record.errors.details[attribute.to_sym] || []).pluck(:error)

    expect(errors).to include(@detail_key)
  end

  chain :with_detail_key do |detail_key|
    @detail_key = detail_key
  end

  description do
    "have_error_on_attribute #{attribute} with_detail_key #{@detail_key.inspect}"
  end

  failure_message do |record|
    "expected #{record} to have error on attribute #{attribute} with detail key #{@detail_key.inspect}"
  end

  failure_message_when_negated do |record|
    "expected #{record} not to have error on attribute #{attribute} with detail key #{@detail_key.inspect}"
  end
end
