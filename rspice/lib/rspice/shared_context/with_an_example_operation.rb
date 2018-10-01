# frozen_string_literal: true

RSpec.shared_context "with an example operation" do
  subject(:example_operation) { example_operation_class.new(state) }

  let(:state) { double }
end
