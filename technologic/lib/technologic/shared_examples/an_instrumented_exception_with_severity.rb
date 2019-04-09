# frozen_string_literal: true

# RSpec shared example of the common behavior between the error raising severity helpers `#error!` and `#fatal!`.
#
# Usage:
#
# let(:test_class) do
#   Class.new do
#     def initialize(user)
#       @user = user
#     end
#
#     def do_a_thing
#       error! SomeBadThing, "Something bad always happens when you do a thing!", user: @user
#     end
#   end
# end
#
# describe "#do_a_thing" do
#   include_examples "an instrumented exception with severity", SomeBadThing, :error! do
#     let(:instance) { test_class.new(user) }
#     let(:user) { instance_double(User) }
#     let(:example_method) { instance.do_a_thing }
#     let(:expected_message) { "Something bad always happens when you do a thing!" }
#     let(:expected_data) do
#       { user: user }
#     end
#   end
# end
RSpec.shared_examples_for "an instrumented exception with severity" do |error_class, severity|
  before { allow(instance).to receive(severity).and_call_original }

  let(:expected_message) { nil }
  let(:expected_data) do
    {}
  end
  let(:expected_arguments) do
    [ error_class, expected_message ].tap { |arr| arr << expected_data unless expected_data.empty? }.compact
  end

  it "raises and logs" do
    expect { example_method }.to raise_error error_class, expected_message
    expect(instance).to have_received(severity).with(*expected_arguments)
  end
end
