# frozen_string_literal: true

# RSpec context that defines callbacks for [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks)
#
#     class Klass
#       include ActiveSupport::Callbacks
#       define_callbacks :kallback
#
#       def call
#         run_callbacks(:kallback)
#       end
#     end
#
#     RSpec.describe Klass do
#       it_behaves_like "a class with callback" do
#         include_context "with callbacks", :kallback
#
#         subject(:callback_runner) { described_class.new.call }
#
#         let(:example_class) { described_class }
#       end
#     end

RSpec.shared_context "with class callbacks" do |callback|
  before do
    example_class.class_eval { class << self; attr_accessor :before_hook_run, :around_hook_run, :after_hook_run; end }
    example_class.set_callback(callback, :before) { |obj| obj.class.before_hook_run = true }
    example_class.set_callback(callback, :after) { |obj| obj.class.after_hook_run = true }
    example_class.set_callback callback, :around do |obj, block|
      obj.class.around_hook_run = true
      block.call
    end
  end
end
