# frozen_string_literal: true

# RSpec shared context for adding a callback to a class which includes `ActiveSupport::Callbacks`.
#
# Usage:
#
# class TestClass
#   include ActiveSupport::Callbacks
#   define_callbacks :foo
#
#   def foo
#     run_callbacks(:foo)
#   end
# end
#
#
# RSpec.describe TestClass do
#   it_behaves_like "a class with callback" do
#     include_context "with callbacks", :foo
#
#     subject(:callback_runner) { described_class.new.foo }
#
#     let(:example_class) { described_class }
#   end
# end

RSpec.shared_context "with callbacks" do |callback|
  before do
    example_class.attr_accessor :before_hook_run, :around_hook_run, :after_hook_run
    example_class.set_callback(callback, :before) { |obj| obj.before_hook_run = true }
    example_class.set_callback(callback, :after) { |obj| obj.after_hook_run = true }
    example_class.set_callback callback, :around do |obj, block|
      obj.around_hook_run = true
      block.call
    end
  end
end
