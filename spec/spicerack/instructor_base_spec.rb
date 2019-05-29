# frozen_string_literal: true

RSpec.describe Spicerack::InstructorBase, type: :instructor do
  subject { described_class }

  it { is_expected.to inherit_from Spicerack::AscriptorBase }
  it { is_expected.to include_module ActiveModel::Model }
  it { is_expected.to include_module ActiveModel::Validations::Callbacks }
  it { is_expected.to include_module Instructor::Core }
  it { is_expected.to include_module Instructor::Arguments }
  it { is_expected.to include_module Instructor::Options }
end
