# frozen_string_literal: true

# RSpec shared example to spec a class which supports inheritance on class based properties
#
# Usage:
#
# module State::Attributes
#   extend ActiveSupport::Concern
#
#   included do
#     class_attribute :_attributes, instance_writer: false, default: []
#   end
#
#   class_methods do
#     def inherited(base)
#       base._attributes = _attributes.dup
#       super
#     end
#
#     def define_attribute(attribute)
#       _attributes << attribute
#     end
#   end
# end
#
# RSpec.describe State::Attributes, type: :module do
#   let(:example_class) { Class.new.include(State::Attributes) }
#
#   describe ".inherited" do
#     it_behaves_like "an inherited property", :define_attribute, :_attributes do
#       let(:root_class) { example_class }
#     end
#   end
# end

RSpec.shared_examples_for "an inherited property" do |property, attribute = "_#{property.to_s.pluralize}".to_sym|
  let(:base_class) do
    Class.new(root_class).tap { |klass| klass.__send__(property, :base) }
  end

  let(:parentA_class) do
    Class.new(base_class).tap { |klass| klass.__send__(property, :parentA) }
  end

  let(:parentB_class) do
    Class.new(base_class).tap { |klass| klass.__send__(property, :parentB) }
  end

  let!(:childA1_class) do
    Class.new(parentA_class).tap { |klass| klass.__send__(property, :childA1) }
  end

  let!(:childA2_class) do
    Class.new(parentA_class).tap { |klass| klass.__send__(property, :childA2) }
  end

  let!(:childB_class) do
    Class.new(parentB_class).tap { |klass| klass.__send__(property, :childB) }
  end

  let(:expected_attribute_value) { expected_property_value }

  shared_examples_for "an object with inherited property" do
    it "has expected property" do
      expect(example_class.public_send(attribute)).to match_array expected_attribute_value
    end
  end

  describe "#base_class" do
    subject(:example_class) { base_class }

    let(:expected_property_value) { %i[base] }

    include_examples "an object with inherited property"
  end

  describe "#parentA" do
    subject(:example_class) { parentA_class }

    let(:expected_property_value) { %i[base parentA] }

    include_examples "an object with inherited property"
  end

  describe "#parentB" do
    subject(:example_class) { parentB_class }

    let(:expected_property_value) { %i[base parentB] }

    include_examples "an object with inherited property"
  end

  describe "#childA1" do
    subject(:example_class) { childA1_class }

    let(:expected_property_value) { %i[base parentA childA1] }

    include_examples "an object with inherited property"
  end

  describe "#childA2" do
    subject(:example_class) { childA2_class }

    let(:expected_property_value) { %i[base parentA childA2] }

    include_examples "an object with inherited property"
  end

  describe "#childB" do
    subject(:example_class) { childB_class }

    let(:expected_property_value) { %i[base parentB childB] }

    include_examples "an object with inherited property"
  end
end
