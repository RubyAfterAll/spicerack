# frozen_string_literal: true

# RSpec example that tests usage of [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks)
#
#     module Nodule
#       def call
#         run_callbacks(:kallback)
#       end
#     end
#
#     RSpec.describe Nodule do
#       include_context "with example class having callback", :kallback
#
#       subject(:instance) { example_class.new }
#
#       let(:example_class) { example_class_having_callback.include(Nodule) }
#
#       it_behaves_like "a class with callback" do
#         subject(:callback_runner) { instance.call }
#
#         let(:example) { example_class }
#       end
#     end

RSpec.shared_examples_for "a class with callback" do
  it "runs the callbacks" do
    expect { callback_runner }.
      to change { example.before_hook_run }.from(nil).to(true).
      and change { example.around_hook_run }.from(nil).to(true).
      and change { example.after_hook_run }.from(nil).to(true)
  end
end
