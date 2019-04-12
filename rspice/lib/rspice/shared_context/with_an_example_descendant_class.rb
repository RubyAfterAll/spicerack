# frozen_string_literal: true

# RSpec context that creates a named descendant of `described_class`
#
#     class Klass; end
#
#     RSpec.describe Klass do
#       include_context "with an example descendant class"
#
#       let(:example_class_name) { "ChildClass" }
#
#       it "has a descendant class" do
#         expect(example_class.name).to eq example_class_name
#         expect(ChildClass).to inherit_from described_class
#       end
#     end

RSpec.shared_context "with an example descendant class" do
  let(:example_class) { Class.new(described_class) }
  let(:example_class_name) { Faker::Internet.domain_word.capitalize }

  before { stub_const(example_class_name, example_class) }
end
