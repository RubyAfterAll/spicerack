# frozen_string_literal: true

# RSpec shared example to spec a class which uses `ActiveSupport::Callbacks`.
#
# Usage:
#
# module State::Core
#   extend ActiveSupport::Concern
#
#   def initialize
#     run_callbacks(:initialize)
#   end
# end
#
# RSpec.describe State::Core, type: :module do
#   describe "#initialize" do
#     include_context "with example class having callback", :initialize
#
#     subject(:instance) { example_class.new }
#
#     let(:example_class) { example_class_having_callback.include(State::Core) }
#
#     it_behaves_like "a class with callback" do
#       subject(:callback_runner) { instance }
#
#       let(:example) { example_class }
#     end
#   end
# end

RSpec.shared_examples_for "a class with callback" do
  it "runs the callbacks" do
    expect { callback_runner }.
      to change { example.before_hook_run }.from(nil).to(true).
      and change { example.around_hook_run }.from(nil).to(true).
      and change { example.after_hook_run }.from(nil).to(true)
  end
end
