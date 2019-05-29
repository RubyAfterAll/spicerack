# frozen_string_literal: true

RSpec.shared_context "with an example input object" do |extra_input_object_modules = nil|
  subject(:example_input_object) { example_input_object_class.new(**input) }

  let(:root_input_object_modules) { [] }
  let(:input_object_modules) { root_input_object_modules + Array.wrap(extra_input_object_modules) }

  let(:root_input_object_class) { Class.new(Spicerack::InputObject) }
  let(:example_input_object_class) do
    root_input_object_class.tap do |input_object_class|
      input_object_modules.each { |input_object_module| input_object_class.include input_object_module }
    end
  end

  let(:input) do
    {}
  end
end
