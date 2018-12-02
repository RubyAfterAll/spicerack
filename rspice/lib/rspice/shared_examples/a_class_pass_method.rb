# frozen_string_literal: true

RSpec.shared_examples_for "a class pass method" do |method|
  subject do
    if accepts_block?
      test_class.public_send(method, *arguments, &block)
    else
      test_class.public_send(method, *arguments)
    end
  end

  let(:test_class) { described_class }

  let(:method_parameters) { test_class.instance_method(:initialize).parameters }
  let(:argument_arity) { method_parameters.map(&:first).select { |type| type.in?(%i[req opt]) }.length }
  let(:option_keys) { method_parameters.select { |param| param.first.in?(%i[key keyreq]) }.map(&:last) }
  let(:accepts_block?) { method_parameters.any? { |param| param.first == :block } }

  let(:arguments) do
    Array.new(argument_arity) { double }.tap do |array|
      array << options if options.present?
    end
  end
  let(:options) { option_keys.each_with_object({}) { |key, hash| hash[key] = Faker::Lorem.word } }
  let(:block) { -> {} }
  let(:instance) { instance_double(test_class) }
  let(:output) { double }

  before do
    allow(instance).to receive(method).and_return(output)

    if accepts_block?
      allow(test_class).to receive(:new).with(*arguments, &block).and_return(instance)
    elsif arguments.any?
      allow(test_class).to receive(:new).with(*arguments).and_return(instance)
    else
      allow(test_class).to receive(:new).with(no_args).and_return(instance)
    end
  end

  it { is_expected.to eq output }

  it "has matching parameters with initialize" do
    expect(test_class.method(method).parameters).to eq test_class.instance_method(:initialize).parameters
  end
end
