# frozen_string_literal: true

RSpec.describe RootObject::Base, type: :root_object do
  subject { described_class }

  it { is_expected.to include_module ActiveSupport::Callbacks }
  it { is_expected.to include_module ShortCircuIt }
  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module Tablesalt::StringableObject }
end
