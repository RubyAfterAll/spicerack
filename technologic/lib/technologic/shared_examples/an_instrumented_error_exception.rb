# frozen_string_literal: true

# RSpec shared example to spec usage of `#error!`.
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
#       fatal! SomeBadThing, "Something bad always happens when you do a thing!", user: @user
#     end
#   end
# end
#
# describe "#do_a_thing" do
#   include_examples "an instrumented fatal exception", SomeBadThing do
#     let(:instance) { test_class.new(user) }
#     let(:user) { instance_double(User) }
#     let(:example_method) { instance.do_a_thing }
#     let(:expected_message) { "Something terrible always happens when you do a thing!" }
#     let(:expected_data) do
#       { user: user }
#     end
#   end
# end
RSpec.shared_examples_for "an instrumented fatal exception" do |error_class|
  include_examples "an instrumented exception with severity", error_class, :fatal!
end
