# frozen_string_literal: true

# RSpec matcher that tests usages of [ActiveModel::Errors](https://api.rubyonrails.org/classes/ActiveModel/Errors.html)
#
#     class Klass < ApplicationRecord
#       validate_uniqueness_of :attribute
#     end
#
#     RSpec.describe Klass, type: :model do
#       subject(:klass) { model.new(attribute: attribute) }
#
#       let(:attribute) { "attribute" }
#
#       before do
#         model.create(attribute: attribute)
#         klass.validate
#       end
#
#       it { is_expected.to have_error_on_attribute(:attribute).with_detail_key(:taken) }
#     end

RSpec::Matchers.define :have_error_on_attribute do |attribute|
  attr_reader :record, :attribute

  match do |record|
    raise ArgumentError, "have_error_on_attribute matcher requires a detail_key" if @detail_key.blank?

    @record = record
    @attribute = attribute

    error_present? && translation_present?
  end

  match_when_negated do |record|
    raise ArgumentError, "have_error_on_attribute matcher requires a detail_key" if @detail_key.blank?

    @record = record
    @attribute = attribute

    !error_present?
  end

  chain :with_detail_key do |detail_key|
    @detail_key = detail_key
  end

  description do
    "have_error_on_attribute #{attribute} with_detail_key #{@detail_key.inspect}"
  end

  failure_message do |record|
    if translation_present?
      "expected #{record} to have error on attribute #{attribute} with detail key #{@detail_key.inspect}, got #{@errors}"
    else
      missing_translation_failure_message
    end
  end

  failure_message_when_negated do |record|
    "expected #{record} not to have error on attribute #{attribute} with detail key #{@detail_key.inspect}"
  end

  def errors
    @errors ||= (record.errors.details[attribute.to_sym] || []).pluck(:error).map(&:to_sym)
  end

  def error_present?
    errors&.include?(@detail_key.to_sym)
  end

  def translation_present?
    return @translation_present if defined?(@translation_present)

    @translation_present ||= begin
      record.errors[attribute.to_sym]
      true
    rescue *[ (I18n::MissingTranslationData if defined?(I18n::MissingTranslationData)) ] => exception # rubocop:disable Lint/RedundantSplatExpansion
      @missing_translation_error = exception
      false
    end
  end

  def missing_translation_failure_message
    message = <<~MESSAGE
      expected error #{@detail_key.inspect} was present, but is missing a translation at key:
        #{@missing_translation_error.key}
    MESSAGE

    if defined?(Rails) && Rails.application.present?
      message << "\nIf this is ok, try setting config.i18n.raise_on_missing_translations = false in config/environments/test.rb"
    end

    message
  end
end
