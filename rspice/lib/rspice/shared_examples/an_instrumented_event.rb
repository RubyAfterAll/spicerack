# frozen_string_literal: true

# RSpec shared example to spec usage of `ActiveSupport::Notification#instrumentation`.
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
#       ActiveSupport::Notifications.instrument("a_thing_was_done.namespace", user: @user)
#     end
#   end
# end
#
# describe "#do_a_thing" do
#   subject(:do_a_thing) { instance.do_a_thing }
#
#   let(:instance) { test_class.new(user) }
#   let(:user) { double }
#
#   before { do_a_thing }
#
#   it_behaves_like "an instrumented event", "a_thing_was_done.namespace" do
#     let(:expected_data) do
#       { user: user }
#     end
#   end
# end

RSpec.shared_examples_for "an instrumented event" do |event_name|
  subject { ActiveSupport::Notifications }

  let(:expected_event) { event_name }

  let(:expected_data) do
    {}
  end

  let(:expected_args) do
    [ expected_event ].push(expected_data).compact
  end

  it { is_expected.to have_received(:instrument).with(*expected_args) }
end
