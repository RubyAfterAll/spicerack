# frozen_string_literal: true

# RSpec example that tests usage of `#surveil`
#
#     class Klass
#       include Technologic
#
#       def initialize(user)
#         @user = user
#       end
#
#       def do_a_thing
#         surveil(:doing_a_thing, user: @user) { :a_thing_is_done }
#       end
#     end
#
#     RSpec.describe Klass do
#       let(:instance) { described_class.new(user) }
#       let(:user) { double }
#
#       before { instance.do_a_thing }
#
#       it_behaves_like "a surveiled event", :doing_a_thing do
#         let(:expected_data) do
#           { user: user }
#         end
#       end
#     end

RSpec.shared_examples_for "a surveiled event" do |expected_event|
  subject { ActiveSupport::Notifications }

  let(:expected_class) { described_class }
  let(:expected_args_start) { [ "#{expected_event}_started.#{expected_class}.info", expected_data ] }
  let(:expected_args_finished) { [ "#{expected_event}_finished.#{expected_class}.info", {} ] }
  let(:expected_data) do
    {}
  end
  let(:frequency) { :once }

  it { is_expected.to have_received(:instrument).with(*expected_args_start).exactly(frequency) }
  it { is_expected.to have_received(:instrument).with(*expected_args_finished).exactly(frequency) }
end
