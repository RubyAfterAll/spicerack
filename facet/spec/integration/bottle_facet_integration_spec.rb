# frozen_string_literal: true

RSpec.describe BottleFacet, type: :integration do
  include_context "with example bottles"

  subject(:facet) { described_class.new }

  describe "#cache_key" do
    subject { facet.cache_key }

    context "when not paginated, sorted, or filtered" do
      let(:facet) { described_class.new(paginate: false) }

      it { is_expected.to eq [ facet.collection, nil, nil, nil ] }
    end

    context "when paginated but neither sorted nor filtered" do
      let(:facet) { described_class.new }

      it { is_expected.to eq [ facet.collection, 1, nil, nil ] }
    end

    context "when sorted newest_first but neither paginated nor filtered" do
      let(:facet) { described_class.new(sort_by: :newest_first, paginate: false) }

      it { is_expected.to eq [ facet.collection, nil, nil, :newest_first ] }
    end

    context "when paginated and sorted newest_first but not filtered" do
      let(:facet) { described_class.new(sort_by: :newest_first) }

      it { is_expected.to eq [ facet.collection, 1, nil, :newest_first ] }
    end

    context "when filtered unbroken but neither paginated nor sorted" do
      let(:facet) { described_class.new(filter_by: :unbroken, paginate: false) }

      it { is_expected.to eq [ facet.collection, nil, :unbroken, nil ] }
    end

    context "when paginated and filtered broken but not sorted" do
      let(:facet) { described_class.new(filter_by: :broken) }

      it { is_expected.to eq [ facet.collection, 1, :broken, nil ] }
    end

    context "when paginated, filtered unbroken and sorted newest_first" do
      let(:facet) { described_class.new(filter_by: :unbroken, sort_by: :newest_first) }

      it { is_expected.to eq [ facet.collection, 1, :unbroken, :newest_first ] }
    end

    context "when paged, filtered unbroken and sorted newest_first" do
      let(:facet) { described_class.new(current_page: 2, filter_by: :unbroken, sort_by: :newest_first) }

      it { is_expected.to eq [ facet.collection, 2, :unbroken, :newest_first ] }
    end
  end

  describe "#output" do
    subject { facet.output }

    context "when not paginated, sorted, or filtered" do
      let(:facet) { described_class.new(paginate: false) }

      it { is_expected.to eq Bottle.all }
    end

    context "when paginated but neither sorted nor filtered" do
      let(:facet) { described_class.new }

      it { is_expected.to eq Bottle.first(Bottle.per_page) }
    end

    context "when sorted newest_first but neither paginated nor filtered" do
      let(:facet) { described_class.new(sort_by: :newest_first, paginate: false) }

      it { is_expected.to eq Bottle.all.reverse }
    end

    context "when paginated and sorted newest_first but not filtered" do
      let(:facet) { described_class.new(sort_by: :newest_first) }

      it { is_expected.to eq Bottle.all.reverse.take(Bottle.per_page) }
    end

    context "when filtered unbroken but neither paginated nor sorted" do
      let(:facet) { described_class.new(filter_by: :unbroken, paginate: false) }

      it { is_expected.to eq Bottle.unbroken }
    end

    context "when paginated and filtered broken but not sorted" do
      let(:facet) { described_class.new(filter_by: :unbroken) }

      it { is_expected.to eq Bottle.unbroken.take(Bottle.per_page) }
    end

    context "when paginated, filtered unbroken and sorted newest_first" do
      let(:facet) { described_class.new(filter_by: :unbroken, sort_by: :newest_first) }

      it { is_expected.to eq Bottle.unbroken.reverse.take(Bottle.per_page) }
    end

    context "when paged, filtered unbroken and sorted newest_first" do
      let(:facet) { described_class.new(current_page: 2, filter_by: :unbroken, sort_by: :newest_first) }

      it { is_expected.to match_array Bottle.unbroken.reverse.in_groups_of(Bottle.per_page)[1].compact }
    end
  end

  describe "predicates" do
    subject { facet }

    context "when not paginated, sorted, or filtered" do
      let(:facet) { described_class.new(paginate: false) }

      it { is_expected.not_to be_paginated }
      it { is_expected.not_to be_sorted }
      it { is_expected.not_to be_filtered }
     end

    context "when paginated but neither sorted nor filtered" do
      let(:facet) { described_class.new }

      it { is_expected.to be_paginated }
      it { is_expected.not_to be_sorted }
      it { is_expected.not_to be_filtered }
    end

    context "when sorted newest_first but neither paginated nor filtered" do
      let(:facet) { described_class.new(sort_by: :newest_first, paginate: false) }

      it { is_expected.not_to be_paginated }
      it { is_expected.to be_sorted }
      it { is_expected.not_to be_filtered }
    end

    context "when paginated and sorted newest_first but not filtered" do
      let(:facet) { described_class.new(sort_by: :newest_first) }

      it { is_expected.to be_paginated }
      it { is_expected.to be_sorted }
      it { is_expected.not_to be_filtered }
    end

    context "when filtered unbroken but neither paginated nor sorted" do
      let(:facet) { described_class.new(filter_by: :unbroken, paginate: false) }

      it { is_expected.not_to be_paginated }
      it { is_expected.not_to be_sorted }
      it { is_expected.to be_filtered }
    end

    context "when paginated and filtered broken but not sorted" do
      let(:facet) { described_class.new(filter_by: :unbroken) }

      it { is_expected.to be_paginated }
      it { is_expected.not_to be_sorted }
      it { is_expected.to be_filtered }
    end

    context "when paginated, filtered unbroken and sorted newest_first" do
      let(:facet) { described_class.new(filter_by: :unbroken, sort_by: :newest_first) }

      it { is_expected.to be_paginated }
      it { is_expected.to be_sorted }
      it { is_expected.to be_filtered }
    end

    context "when paged, filtered unbroken and sorted newest_first" do
      let(:facet) { described_class.new(current_page: 2, filter_by: :unbroken, sort_by: :newest_first) }

      it { is_expected.to be_paginated }
      it { is_expected.to be_sorted }
      it { is_expected.to be_filtered }
    end
  end
end
