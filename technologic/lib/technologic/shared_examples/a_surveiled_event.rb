# frozen_string_literal: true

# RSpec shared example to spec usage `#surveil`.
#
# Usage:
#
# class TestClass
#   include Technologic
#
#   def initialize(user)
#     @user = user
#   end
#
#   def do_a_thing
#     surveil(:doing_a_thing, user: @user) { :a_thing_is_done }
#   end
# end
#
# RSpec.describe TestClass do
#   describe "#do_a_thing" do
#     let(:instance) { described_class.new(user) }
#     let(:user) { double }
#
#     before { instance.do_a_thing }
#
#     it_behaves_like "a surveiled event", :doing_a_thing do
#       let(:expected_data) do
#         { user: user }
#       end
#     end
#   end
# end

RSpec.shared_examples_for "a surveiled event" do |expected_event|
  subject { ActiveSupport::Notifications }

  let(:expected_class) { described_class }
  let(:expected_args_start) { [ "#{expected_event}_started.#{expected_class}.info", expected_data ] }
  let(:expected_args_finished) { [ "#{expected_event}_finished.#{expected_class}.info", {} ] }
  let(:expected_data) do
    {}
  end

  it { is_expected.to have_received(:instrument).with(*expected_args_start) }
  it { is_expected.to have_received(:instrument).with(*expected_args_finished) }
end
