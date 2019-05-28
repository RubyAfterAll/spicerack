# frozen_string_literal: true

RSpec.describe Instructor::Base, type: :instructor do
  subject { described_class }

  it { is_expected.to include_module ShortCircuIt }
  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module ActiveModel::Model }
  it { is_expected.to include_module ActiveModel::Validations::Callbacks }
  it { is_expected.to include_module Tablesalt::StringableObject }
  it { is_expected.to include_module Tablesalt::Dsl::Defaults }
  it { is_expected.to include_module Instructor::Callbacks }
  it { is_expected.to include_module Instructor::Attributes }
  it { is_expected.to include_module Instructor::Arguments }
  it { is_expected.to include_module Instructor::Options }
  it { is_expected.to include_module Instructor::Core }
end
