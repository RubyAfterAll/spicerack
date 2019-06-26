# frozen_string_literal: true

# RSpec example that tests usage of named severity log handlers (used to DRY out other shared examples)
#
#     class Klass
#       include Technologic
#
#       def initialize(user)
#         @user = user
#       end
#
#       def do_a_thing
#         info :thing_being_done, user: @user
#       end
#     end
#
#     RSpec.describe Klass do
#       let(:instance) { described_class.new(user) }
#       let(:user) { double }
#
#       before { instance.do_a_thing }
#
#       it_behaves_like "a logged event with severity", :thing_being_done, :info do
#         let(:expected_data) do
#           { user: user }
#         end
#       end
#     end

RSpec.shared_examples_for "a logged event with severity" do |event, severity, for_class = described_class|
  let(:expected_class) { for_class }

  include_examples "an instrumented event"

  let(:expected_event) { "#{event}.#{expected_class}.#{severity}" }
end
