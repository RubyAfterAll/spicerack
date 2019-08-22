# frozen_string_literal: true

RSpec.describe Tablesalt::DSLAccessor do
  let(:including_class) do
    Class.new.instance_exec(self) do |spec_context|
      include spec_context.described_class
    end
  end

  let(:accessor) { Faker::Lorem.word }

  describe ".dsl_accessor" do
    let(:accessor_name) { Faker::Lorem.words(3).join("_").downcase }

    before do
      including_class.instance_exec(self) do |spec_context|
        dsl_accessor spec_context.accessor
      end
    end

    it "does not define a public singleton method" do
      expect { including_class.public_send(accessor, Faker::Lorem.word) }.to raise_error NoMethodError
    end

    it "defines a private method with the passed name" do
      expect { including_class.__send__(accessor, Faker::Lorem.word) }.not_to raise_error
    end

    context "when passed multiple arguments" do
      let(:accessors) { Faker::Lorem.words(rand(2..4)).uniq }

      before do
        including_class.instance_exec(self) do |spec_context|
          spec_context.accessors.each do |accessor|
            dsl_accessor accessor
          end
        end
      end

      it "does not define a public method for each argument" do
        accessors.each do |accessor|
          expect { including_class.public_send(accessor) }.to raise_error NoMethodError
        end
      end

      it "defines a private method for each argument" do
        accessors.each do |accessor|
          expect { including_class.__send__(accessor) }.not_to raise_error NoMethodError
        end
      end
    end

    describe "defined accessor" do
      subject(:dsl) { including_class.__send__(accessor, *args) }

      let(:new_value) { Faker::Hipster.sentence }

      context "when a value has not been defined" do
        context "when passed no arguments" do
          let(:args) { [] }

          it "raises" do
            expect { dsl }.to raise_error ArgumentError, "wrong number of arguments (given #{args.size}, expected 1)"
          end
        end

        context "when passed 1 argument" do
          let(:args) { [ new_value ] }

          it { is_expected.to eq new_value }

          context "when subsequently called without arguments" do
            subject { including_class.__send__(accessor) }

            before { dsl }

            it { is_expected.to eq args.first }
          end
        end

        context "when passed more than 1 argument" do
          let(:args) { Array.new(rand(2..5)) { rand } }

          it "raises" do
            expect { dsl }.to raise_error ArgumentError, "wrong number of arguments (given #{args.size}, expected 1)"
          end
        end
      end

      context "when a value has been defined" do
        let(:pre_defined_value) { Faker::ChuckNorris.fact }

        before { including_class.__send__(accessor, pre_defined_value) }

        context "when passed no arguments" do
          let(:args) { [] }

          it { is_expected.to eq pre_defined_value }
        end

        context "when passed 1 argument" do
          let(:args) { [ new_value ] }

          it "raises" do
            expect { dsl }.to raise_error NameError, "internal attribute #{accessor} already set"
          end
        end

        context "when passed more than 1 argument" do
          let(:args) { Array.new(rand(2..5)) { new_value } }

          it "raises" do
            expect { dsl }.to raise_error ArgumentError, "wrong number of arguments (given #{args.size}, expected 0)"
          end
        end
      end
    end
  end
end
