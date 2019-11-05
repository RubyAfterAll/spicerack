# frozen_string_literal: true

RSpec.describe Conjunction::Junction, type: :junction do
  include_context "with an example junction"

  it { is_expected.to include_module Conjunction::Conjunctive }
  it { is_expected.to include_module Conjunction::NamingConvention }

  describe ".junction_key" do
    subject { example_junction_class.junction_key }

    context "without configuration" do
      let(:junction_prefix) { nil }
      let(:junction_suffix) { nil }

      it { is_expected.to eq :"" }
    end

    context "with only prefix" do
      let(:junction_suffix) { nil }

      it { is_expected.to eq junction_prefix.downcase.to_sym }
    end

    context "with only suffix" do
      let(:junction_prefix) { nil }

      it { is_expected.to eq junction_suffix.downcase.to_sym }
    end

    context "with both prefix and suffix" do
      it { is_expected.to eq "#{junction_prefix.downcase}_#{junction_suffix.downcase}".to_sym }
    end
  end

  describe ".prototype_name" do
    subject { example_junction_class.prototype_name }

    context "without configuration" do
      let(:junction_prefix) { nil }
      let(:junction_suffix) { nil }

      it { is_expected.to be_nil }
    end

    context "with only prefix" do
      let(:junction_suffix) { nil }

      it { is_expected.to eq prototype_name }
    end

    context "with only suffix" do
      let(:junction_prefix) { nil }

      it { is_expected.to eq prototype_name }
    end

    context "with both prefix and suffix" do
      it { is_expected.to eq prototype_name }
    end
  end
end
