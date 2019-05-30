# frozen_string_literal: true

# RSpec example that tests usage of `#debug`
#
#     class Klass
#       include Technologic
#
#       def initialize(user)
#         @user = user
#       end
#
#       def do_a_thing
#         debug :thing_being_done, user: @user
#       end
#     end
#
#     RSpec.describe Klass do
#       let(:instance) { described_class.new(user) }
#       let(:user) { double }
#
#       before { instance.do_a_thing }
#
#       it_behaves_like "a debug event is logged", :thing_being_done do
#         let(:expected_data) do
#           { user: user }
#         end
#       end
#     end

RSpec.shared_examples_for "a debug event is logged" do |event, for_class = described_class|
  include_examples "a logged event with severity", event, :debug, for_class
end
