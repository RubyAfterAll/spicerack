# frozen_string_literal: true

# RSpec example that tests usage of `#fatal!`
#
#     class Klass
#       include Technologic
#
#       def initialize(user)
#         @user = user
#       end
#
#       def do_a_thing
#         fatal! RuntimeError, "Something terrible always happens when you do a thing!", user: @user
#       end
#     end
#
#     RSpec.describe Klass do
#       include_examples "an instrumented fatal exception", RuntimeError do
#         let(:instance) { described_class.new(user) }
#         let(:user) { double }
#         let(:example_method) { instance.do_a_thing }
#         let(:expected_message) { "Something terrible always happens when you do a thing!" }
#         let(:expected_data) do
#           { user: user }
#         end
#       end
#     end

RSpec.shared_examples_for "an instrumented fatal exception" do |error_class|
  include_examples "an instrumented exception with severity", error_class, :fatal!
end
