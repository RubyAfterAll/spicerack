# frozen_string_literal: true

RSpec.shared_context "with an example output object" do
  subject(:example_output_object) { example_output_object_class.new(**input) }

  let(:example_output_object_class) { Class.new(Substance::OutputObject) }

  let(:input) { {} }

  let(:example_name) { Faker::Internet.domain_word.underscore.camelize }
  let(:example_output_object_name) { "#{example_name}State" }

  before { stub_const(example_output_object_name, example_output_object_class) }
end
