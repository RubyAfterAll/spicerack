# frozen_string_literal: true

RSpec.shared_examples_for "an encoder" do
  let(:expected_attributes) do
    { target_class: target_class, method: method, class_arguments: class_arguments, method_arguments: method_arguments }
  end

  it { is_expected.to have_attributes(expected_attributes) }
end
