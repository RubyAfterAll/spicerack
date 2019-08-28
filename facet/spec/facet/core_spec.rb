# frozen_string_literal: true

RSpec.describe Facet::Core do
  include_context "with an example facet"

  describe "#initialize" do
    context "without .default_filter" do
      context "with no arguments" do
        subject(:example_facet) { example_facet_class.new }

        it "uses defaults" do
          expect(example_facet.current_page).to eq 0
          expect(example_facet.filter_by).to be_nil
          expect(example_facet.sort_by).to be_nil
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
        end
      end
    end

    context "with .default_filter" do
      let(:default_filter) { double }

      before { example_facet_class.__send__(:filter_default, default_filter) }

      context "with no arguments" do
        subject(:example_facet) { example_facet_class.new }

        it "uses defaults" do
          expect(example_facet.current_page).to eq 0
          expect(example_facet.filter_by).to eq default_filter
          expect(example_facet.sort_by).to be_nil
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
        end

        context "without filter_by" do
          let(:filter_by) { nil }

          context "when all: false" do
            let(:all) { false }

            it "uses default" do
              expect(example_facet.current_page).to eq current_page
              expect(example_facet.filter_by).to eq default_filter
              expect(example_facet.sort_by).to eq sort_by
            end
          end

          context "when all: true" do
            let(:all) { true }

            it "uses arguments" do
              expect(example_facet.current_page).to eq current_page
              expect(example_facet.filter_by).to be_nil
              expect(example_facet.sort_by).to eq sort_by
            end
          end
        end
      end
    end
  end
end
