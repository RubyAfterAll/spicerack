# frozen_string_literal: true

RSpec.shared_context "with an example descendant class" do
  let(:example_class) { Class.new(described_class) }
  let(:example_class_name) { Faker::Internet.domain_word.capitalize }

  before { stub_const(example_class_name, example_class) }
end
