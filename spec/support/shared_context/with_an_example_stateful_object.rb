# frozen_string_literal: true

RSpec.shared_context "with an example stateful object" do
  subject(:example_stateful_object) { example_stateful_object_class.new(**input) }

  let(:example_stateful_object_class) { Class.new(Spicerack::StatefulObject) }

  let(:input) { {} }

  let(:example_name) { Faker::Internet.domain_word.capitalize }
  let(:example_stateful_object_name) { "#{example_name}State" }

  before { stub_const(example_stateful_object_name, example_stateful_object_class) }
end
