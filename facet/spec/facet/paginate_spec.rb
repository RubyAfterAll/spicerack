# frozen_string_literal: true

RSpec.describe Facet::Paginate, type: :concern do
  include_context "with an example facet"

  it { is_expected.to delegate_method(:default_page).to(:class) }
  it { is_expected.to delegate_method(:default_page?).to(:class) }
  it { is_expected.to delegate_method(:pagination?).to(:class) }

  describe ".default_page" do
    subject { example_facet_class.default_page }

    context "with default" do
      it { is_expected.to eq 1 }
    end

    context "when specified" do
      before { example_facet_class.__send__(:page_default, default_page) }

      let(:default_page) { double }

      it { is_expected.to eq default_page }
    end

    context "without pagination" do
      before { example_facet_class.__send__(:disable_pagination!) }

      it { is_expected.to eq(-1) }
    end
  end

  describe ".page_default" do
    subject(:page_default) { example_facet_class.__send__(:page_default, value) }

    let(:value) { double }

    it "defines .default_page" do
      expect { page_default }.to change { example_facet_class.default_page }.from(1).to(value)
    end
  end

  describe ".default_page?" do
    subject { example_facet_class }

    context "with default" do
      it { is_expected.not_to be_default_page }
    end

    context "when specified" do
      before { example_facet_class.__send__(:page_default, default_page) }

      let(:default_page) { double }

      it { is_expected.to be_default_page }
    end

    context "without pagination" do
      before { example_facet_class.__send__(:disable_pagination!) }

      it { is_expected.to be_default_page }
    end
  end

  describe ".pagination?" do
    subject { example_facet_class }

    context "with default" do
      it { is_expected.to be_pagination }
    end

    context "when specified" do
      before { example_facet_class.__send__(:page_default, default_page) }

      let(:default_page) { 1 }

      it { is_expected.to be_pagination }
    end

    context "without pagination" do
      before { example_facet_class.__send__(:disable_pagination!) }

      it { is_expected.not_to be_pagination }
    end
  end

  describe ".inherited" do
    subject { Class.new(example_facet_class) }

    context "without default" do
      it { is_expected.not_to be_default_page }
    end

    context "with default" do
      before { example_facet_class.__send__(:page_default, double) }

      it { is_expected.to be_default_page }
    end
  end
end
