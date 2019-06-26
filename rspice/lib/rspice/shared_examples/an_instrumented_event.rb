# frozen_string_literal: true

# RSpec example that tests usage of [ActiveSupport::Notification](https://apidock.com/rails/ActiveSupport/Notifications)
#
#     class Klass
#       def initialize(user)
#         @user = user
#       end
#
#       def call
#         ActiveSupport::Notifications.instrument("a_thing_was_done.namespace", user: @user)
#       end
#     end
#
#     RSpec.describe Klass do
#       let(:instance) { test_class.new(user) }
#       let(:user) { double }
#
#       before { instance.call }
#
#       it_behaves_like "an instrumented event", "a_thing_was_done.namespace" do
#         let(:expected_data) do
#           { user: user }
#         end
#       end
#     end

RSpec.shared_examples_for "an instrumented event" do |event_name = nil|
  subject { ActiveSupport::Notifications }

  let(:expected_event) { event_name }
  let(:expected_args) { [ expected_event ].push(expected_data).compact }
  let(:expected_data) do
    {}
  end

  it { is_expected.to have_received(:instrument).with(*expected_args) }
end
