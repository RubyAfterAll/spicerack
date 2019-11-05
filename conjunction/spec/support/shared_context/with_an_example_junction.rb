# frozen_string_literal: true

RSpec.shared_context "with an example junction" do
  subject(:example_junction) { example_junction_class.new }

  let(:example_junction_class) do
    Class.new.tap { |klass| klass.include Conjunction::Junction }
  end

  let(:example_junction_name) { Faker::Internet.domain_word.capitalize }

  before { stub_const(example_junction_name, example_junction_class) }
end
