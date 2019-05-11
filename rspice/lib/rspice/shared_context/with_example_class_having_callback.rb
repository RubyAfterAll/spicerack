# frozen_string_literal: true

# RSpec context that creates a class with [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks)
#
#     module Nodule
#       def call
#         run_callbacks(:kallback)
#       end
#     end
#
#     RSpec.describe Nodule do
#       describe "#initialize" do
#         include_context "with example class having callback", :kallback
#
#         subject(:callback_runner) { example_class.new.call }
#
#         let(:example_class) { example_class_having_callback.include(Nodule) }
#
#         it "runs the callbacks" do
#           expect { callback_runner }.
#             to change { example.before_hook_run }.from(nil).to(true).
#             and change { example.around_hook_run }.from(nil).to(true).
#             and change { example.after_hook_run }.from(nil).to(true)
#         end
#       end
#     end

RSpec.shared_context "with example class having callback" do |callback|
  let(:example_class_having_callback) do
    Class.new do
      include ActiveSupport::Callbacks
      define_callbacks callback

      class << self
        attr_accessor :before_hook_run, :around_hook_run, :after_hook_run
      end

      set_callback(callback, :before) { |obj| obj.class.before_hook_run = true }
      set_callback(callback, :after) { |obj| obj.class.after_hook_run = true }
      set_callback callback, :around do |obj, block|
        obj.class.around_hook_run = true
        block.call
      end
    end
  end
end
