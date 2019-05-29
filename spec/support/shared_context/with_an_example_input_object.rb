# frozen_string_literal: true

RSpec.shared_context "with an example input object" do
  subject(:example_input_object) { example_input_object_class.new(**input) }

  let(:example_input_object_class) { Class.new(Spicerack::InputObject) }

  let(:input) do
    {}
  end
end
