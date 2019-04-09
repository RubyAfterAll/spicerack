# frozen_string_literal: true

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
