# frozen_string_literal: true

RSpec.describe Substance::InputModel, type: :input_model do
  subject { described_class }

  it { is_expected.to inherit_from Substance::InputObject }
  it { is_expected.to extend_module ActiveModel::Naming }
  it { is_expected.to extend_module ActiveModel::Translation }
  it { is_expected.to include_module ActiveModel::Conversion }
  it { is_expected.to include_module ActiveModel::Validations }
  it { is_expected.to include_module ActiveModel::Validations::Callbacks }
end
