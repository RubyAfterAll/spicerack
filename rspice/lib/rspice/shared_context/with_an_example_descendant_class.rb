# frozen_string_literal: true

# RSpec shared context to create an example class which is a descendant of the `described_class`.
#
# Usage:
#
# describe ClassA do
#   include_context "with an example descendant class"
#
#   let(:example_class_name) { "ChildClass" }
#
#   it "has a descendant class now" do
#     expect(ChildClass.ancestors).to include described_class
#   end
# end

RSpec.shared_context "with an example descendant class" do
  let(:example_class) { Class.new(described_class) }
  let(:example_class_name) { Faker::Internet.domain_word.capitalize }

  before { stub_const(example_class_name, example_class) }
end
