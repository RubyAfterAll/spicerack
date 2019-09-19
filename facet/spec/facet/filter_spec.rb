# frozen_string_literal: true

RSpec.describe Facet::Filter, type: :concern do
  include_context "with an example facet"

  it { is_expected.to delegate_method(:default_filter).to(:class) }
  it { is_expected.to delegate_method(:default_filter?).to(:class) }

  describe ".filter_default" do
    subject(:filter_default) { example_facet_class.__send__(:filter_default, value) }

    let(:value) { double }

    it "defines .default_filter" do
      expect { filter_default }.to change { example_facet_class.default_filter }.from(nil).to(value)
    end
  end

  describe ".default_filter?" do
    subject { example_facet_class }

    context "without a default_filter" do
      it { is_expected.not_to be_default_filter }
    end

    context "with a default_filter" do
      before { example_facet_class.__send__(:filter_default, double) }

      it { is_expected.to be_default_filter }
    end
  end

  describe ".inherited" do
    subject { Class.new(example_facet_class) }

    context "without default" do
      it { is_expected.not_to be_default_filter }
    end

    context "with default" do
      before { example_facet_class.__send__(:filter_default, double) }

      it { is_expected.to be_default_filter }
    end
  end
end
