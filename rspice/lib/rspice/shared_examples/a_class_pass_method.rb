# frozen_string_literal: true

# TODO: Jank - this should use Method#parameters, not Method#arity

RSpec.shared_examples_for "a class pass method" do |method|
  subject do
    if takes_options?
      test_class.public_send(method, *arguments, **options)
    else
      test_class.public_send(method, *arguments)
    end
  end

  let(:test_class) { described_class }
  let(:initialize_arity) { test_class.instance_method(:initialize).arity }
  let(:takes_options?) { (initialize_arity < 0) }
  let(:argument_arity) { takes_options? ? (initialize_arity.abs - 1) : initialize_arity }

  let(:arguments) do
    Array.new(argument_arity) { double }
  end
  let(:options) { takes_options? ? Hash[*Faker::Lorem.words(2 * rand(1..2))].symbolize_keys : nil }
  let(:instance) { instance_double(test_class) }
  let(:output) { double }

  before do
    allow(instance).to receive(method).and_return(output)
    if takes_options?
      allow(test_class).to receive(:new).with(*arguments, **options).and_return(instance)
    else
      allow(test_class).to receive(:new).with(*arguments).and_return(instance)
    end
  end

  it { is_expected.to eq output }
end
