# frozen_string_literal: true

RSpec.describe Facet::Sort, type: :concern do
  include_context "with an example facet"

  it { is_expected.to delegate_method(:default_sort).to(:class) }
  it { is_expected.to delegate_method(:default_sort?).to(:class) }

  describe ".sort_default" do
    subject(:sort_default) { example_facet_class.__send__(:sort_default, value) }

    let(:value) { double }

    it "defines .default_sort" do
      expect { sort_default }.to change { example_facet_class.default_sort }.from(nil).to(value)
    end
  end

  describe ".default_sort?" do
    subject { example_facet_class }

    context "without a default_sort" do
      it { is_expected.not_to be_default_sort }
    end

    context "with a default_sort" do
      before { example_facet_class.__send__(:sort_default, double) }

      it { is_expected.to be_default_sort }
    end
  end

  describe ".inherited" do
    subject { Class.new(example_facet_class) }

    context "without default" do
      it { is_expected.not_to be_default_sort }
    end

    context "with default" do
      before { example_facet_class.__send__(:sort_default, double) }

      it { is_expected.to be_default_sort }
    end
  end
end
