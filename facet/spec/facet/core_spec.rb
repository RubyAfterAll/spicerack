# frozen_string_literal: true

RSpec.describe Facet::Core do
  include_context "with an example facet"

  describe "#initialize" do
    context "without .default_filter" do
      context "with no arguments" do
        subject(:example_facet) { example_facet_class.new }

        it "uses defaults" do
          expect(example_facet.current_page).to eq 1
          expect(example_facet.filter_by).to be_nil
          expect(example_facet.sort_by).to be_nil
          expect(example_facet.source).to be_nil
        end
      end

      context "with arguments" do
        let(:current_page) { rand(1..2) }
        let(:filter_by) { Faker::Internet.domain_word.to_sym }
        let(:sort_by) { Faker::Internet.domain_word.to_sym }
        let(:source) { double }

        it "uses arguments" do
          expect(example_facet.current_page).to eq current_page
          expect(example_facet.filter_by).to eq filter_by
          expect(example_facet.sort_by).to eq sort_by
          expect(example_facet.source).to eq source
        end
      end
    end

    context "without pagination" do
      before { example_facet_class.__send__(:disable_pagination!) }

      context "with no arguments" do
        subject(:example_facet) { example_facet_class.new }

        it "uses defaults" do
          expect(example_facet.current_page).to be_nil
          expect(example_facet.filter_by).to be_nil
          expect(example_facet.sort_by).to be_nil
          expect(example_facet.source).to be_nil
        end
      end

      context "with current_page argument" do
        let(:current_page) { 0 }

        it "raises" do
          expect { example_facet }.to raise_error ArgumentError, "pagination is disabled for this facet."
        end
      end
    end

    context "with disabled pagination" do
      context "with no arguments" do
        subject(:example_facet) { example_facet_class.new(paginate: false) }

        it "uses defaults" do
          expect(example_facet.current_page).to be_nil
          expect(example_facet.filter_by).to be_nil
          expect(example_facet.sort_by).to be_nil
          expect(example_facet.source).to be_nil
        end
      end

      context "with also a current_page argument" do
        subject(:example_facet) { example_facet_class.new(paginate: false, current_page: current_page) }

        let(:current_page) { 0 }

        it "raises" do
          expect { example_facet }.to raise_error ArgumentError, "pagination is disabled for this facet."
        end
      end
    end

    context "with .default_filter" do
      let(:default_filter) { double }

      before { example_facet_class.__send__(:filter_default, default_filter) }

      context "with no arguments" do
        subject(:example_facet) { example_facet_class.new }

        it "uses defaults" do
          expect(example_facet.current_page).to eq 1
          expect(example_facet.filter_by).to eq default_filter
          expect(example_facet.sort_by).to be_nil
          expect(example_facet.source).to be_nil
        end
      end

      context "with arguments" do
        let(:current_page) { rand(1..2) }
        let(:filter_by) { Faker::Internet.domain_word.to_sym }
        let(:sort_by) { Faker::Internet.domain_word.to_sym }

        it "uses arguments" do
          expect(example_facet.current_page).to eq current_page
          expect(example_facet.filter_by).to eq filter_by
          expect(example_facet.sort_by).to eq sort_by
          expect(example_facet.source).to be_nil
        end

        context "without filter_by" do
          let(:filter_by) { nil }

          context "when all: false" do
            let(:all) { false }

            it "uses default" do
              expect(example_facet.current_page).to eq current_page
              expect(example_facet.filter_by).to eq default_filter
              expect(example_facet.sort_by).to eq sort_by
              expect(example_facet.source).to be_nil
            end
          end

          context "when all: true" do
            let(:all) { true }

            it "uses arguments" do
              expect(example_facet.current_page).to eq current_page
              expect(example_facet.filter_by).to be_nil
              expect(example_facet.sort_by).to eq sort_by
              expect(example_facet.source).to be_nil
            end
          end
        end
      end
    end

    context "with .default_sort" do
      let(:default_sort) { double }

      before { example_facet_class.__send__(:sort_default, default_sort) }

      context "with no arguments" do
        subject(:example_facet) { example_facet_class.new }

        it "uses defaults" do
          expect(example_facet.current_page).to eq 1
          expect(example_facet.filter_by).to be_nil
          expect(example_facet.sort_by).to eq default_sort
          expect(example_facet.source).to be_nil
        end
      end

      context "with arguments" do
        let(:current_page) { rand(1..2) }
        let(:filter_by) { Faker::Internet.domain_word.to_sym }
        let(:sort_by) { Faker::Internet.domain_word.to_sym }

        it "uses arguments" do
          expect(example_facet.current_page).to eq current_page
          expect(example_facet.filter_by).to eq filter_by
          expect(example_facet.sort_by).to eq sort_by
          expect(example_facet.source).to be_nil
        end
      end
    end
  end

  describe "#paginated?" do
    subject { example_facet }

    context "with default" do
      it { is_expected.to be_paginated }
    end

    context "when specified" do
      let(:current_page) { 2 }

      it { is_expected.to be_paginated }
    end

    context "without pagination" do
      let(:paginate) { false }
      let(:current_page) { nil }

      it { is_expected.not_to be_paginated }
    end
  end

  describe "#filtered?" do
    subject { example_facet }

    context "without filter_by" do
      it { is_expected.not_to be_filtered }
    end

    context "with filter_by" do
      let(:filter_by) { Faker::Internet.domain_word.to_sym }

      it { is_expected.to be_filtered }
    end
  end

  describe "#sorted?" do
    subject { example_facet }

    context "without sort_by" do
      it { is_expected.not_to be_sorted }
    end

    context "with sort_by" do
      let(:sort_by) { Faker::Internet.domain_word.to_sym }

      it { is_expected.to be_sorted }
    end
  end

  describe "#source?" do
    subject { example_facet }

    context "without source" do
      it { is_expected.not_to be_source }
    end

    context "with source" do
      let(:source) { double }

      it { is_expected.to be_source }
    end
  end
end
