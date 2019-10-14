# frozen_string_literal: true

RSpec.describe Facet::Collection, type: :concern do
  include_context "with an example facet"

  it { is_expected.to alias_method :to_ary, :output }
  it { is_expected.to alias_method :to_a, :to_ary }

  it { is_expected.to delegate_method(:to_model).to(:collection) }
  it { is_expected.to delegate_method(:to_partial_path).to(:collection) }

  describe "#collection" do
    subject { example_facet.collection }

    before { stub_const("SomeRecord", record_class) }

    let(:example_facet_class) do
      Class.new(Facet::Base) do
        def self.record_class
          SomeRecord
        end
      end
    end

    let(:record_class) do
      Class.new do
        def self.model_name
          OpenStruct.new(collection: "some_records")
        end

        def self.all
          :mock_collection
        end
      end
    end

    context "without source" do
      it { is_expected.to eq :mock_collection }
    end

    context "with source" do
      let(:source) { double(some_records: source_records) }
      let(:source_records) { double(all: :mock_source_collection) }

      it { is_expected.to eq :mock_source_collection }
    end
  end

  describe "#output" do
    subject { example_facet.output }

    before { allow(example_facet).to receive(:collection).and_return(collection) }

    let(:collection) { double(some_filter: filtered_collection, some_sort: sorted_collection) }
    let(:sorted_collection) { double }
    let(:filtered_collection) { double(some_sort: filtered_sorted_collection) }
    let(:filtered_sorted_collection) { double }

    let(:paginated_results) { double }

    context "without pagination" do
      let(:current_page) { -1 }

      context "with defaults" do
        it { is_expected.to eq collection }
      end

      context "when sorted but not filtered" do
        let(:sort_by) { :some_sort }

        it { is_expected.to eq sorted_collection }
      end

      context "when filtered but not sorted" do
        let(:filter_by) { :some_filter }

        it { is_expected.to eq filtered_collection }
      end

      context "when filtered and sorted" do
        let(:filter_by) { :some_filter }
        let(:sort_by) { :some_sort }

        it { is_expected.to eq filtered_sorted_collection }
      end
    end

    context "with pagination" do
      before { allow(expected_collection).to receive(:paginate).with(page: current_page).and_return(paginated_results) }

      context "with defaults" do
        let(:expected_collection) { collection }

        it { is_expected.to eq paginated_results }
      end

      context "when sorted but not filtered" do
        let(:expected_collection) { sorted_collection }
        let(:sort_by) { :some_sort }

        it { is_expected.to eq paginated_results }
      end

      context "when filtered but not sorted" do
        let(:expected_collection) { filtered_collection }
        let(:filter_by) { :some_filter }

        it { is_expected.to eq paginated_results }
      end

      context "when filtered and sorted" do
        let(:expected_collection) { filtered_sorted_collection }
        let(:filter_by) { :some_filter }
        let(:sort_by) { :some_sort }

        it { is_expected.to eq paginated_results }
      end
    end
  end
end
