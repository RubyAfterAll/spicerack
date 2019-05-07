# frozen_string_literal: true

RSpec.shared_context "with target class having method" do
  let(:target_class) { Class.new.tap { |target| target.define_method(method, -> {}) } }
  let(:class_name) { Faker::Internet.domain_word.capitalize }
  let(:method) { Faker::Internet.domain_word.to_sym }
  let(:class_method) { false }

  let(:class_arguments) { double }
  let(:method_arguments) { double }

  before { stub_const(class_name, target_class) }
end
