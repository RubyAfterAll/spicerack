# frozen_string_literal: true

RSpec.describe Spicerack::Objects::Defaults, type: :module do
  subject(:example_object) { example_dsl_class.new }

  let(:example_dsl_class) do
    Class.new.tap { |klass| klass.include described_class }
  end

  describe ".define_default" do
    let(:attribute) { Faker::Lorem.word.to_sym }

    describe "defines default" do
      let(:static) { Faker::Lorem.word }
      let(:instance) { instance_double(described_class::Value) }
      let(:expected_defaults) { Hash[attribute, instance] }

      shared_examples_for "a default is defined" do
        it "adds to _defaults" do
          expect { define_default }.to change { example_dsl_class._defaults }.from({}).to(expected_defaults)
        end
      end

      context "when no block is given" do
        subject(:define_default) { example_dsl_class.__send__(:define_default, attribute, static: static) }

        before { allow(described_class::Value).to receive(:new).with(static: static).and_return(instance) }

        it_behaves_like "a default is defined"
      end

      context "when a block is given" do
        subject(:define_default) { example_dsl_class.__send__(:define_default, attribute, static: static, &block) }

        let(:block) do
          ->(_) { :block }
        end

        before { allow(described_class::Value).to receive(:new).with(static: static, &block).and_return(instance) }

        it_behaves_like "a default is defined"
      end
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :define_default, :_defaults do
      let(:root_class) { example_dsl_class }
      let(:expected_attribute_value) do
        expected_property_value.each_with_object({}) do |option, hash|
          hash[option] = instance_of(described_class::Value)
        end
      end
    end
  end
end
