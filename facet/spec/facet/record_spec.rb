# frozen_string_literal: true

RSpec.describe Facet::Record, type: :concern do
  include_context "with an example facet"

  it { is_expected.to delegate_method(:record_class).to(:class) }
  it { is_expected.to delegate_method(:record_scope).to(:class) }

  describe ".record_class" do
    subject { example_facet_class.record_class }

    let(:record_class) { Class.new }

    context "with default" do
      before { stub_const(example_facet_root_name, record_class) }

      it { is_expected.to eq record_class }
    end

    context "when explicit" do
      before { stub_const("SomeRecord", record_class) }

      let(:example_facet_class) do
        Class.new(Facet::Base) do
          def self.record_class
            SomeRecord
          end
        end
      end

      it { is_expected.to eq record_class }
    end
  end

  describe ".self_scope" do
    subject { example_facet_class.self_scope }

    let(:collection) { Faker::Internet.domain_word }
    let(:record_class) { double(model_name: double(collection: collection)) }

    before { allow(example_facet_class).to receive(:record_class).and_return(record_class) }

    it { is_expected.to eq collection.to_sym }
  end

  describe ".record_scope" do
    subject { example_facet_class.record_scope }

    context "with default" do
      it { is_expected.to eq :all }
    end

    context "when specified" do
      before { example_facet_class.__send__(:scope, record_scope) }

      let(:record_scope) { Faker::Internet.domain_word.to_sym }

      it { is_expected.to eq record_scope }
    end
  end

  describe ".scoped?" do
    subject { example_facet_class }

    context "with default" do
      it { is_expected.not_to be_scoped }
    end

    context "when specified" do
      before { example_facet_class.__send__(:scope, double) }

      it { is_expected.to be_scoped }
    end
  end

  describe ".inherited"  do
    subject { Class.new(example_facet_class).record_scope }

    context "with default" do
      it { is_expected.to be :all }
    end

    context "with default" do
      before { example_facet_class.__send__(:scope, record_scope) }

      let(:record_scope) { Faker::Internet.domain_word.to_sym }

      it { is_expected.to eq record_scope }
    end
  end
end
