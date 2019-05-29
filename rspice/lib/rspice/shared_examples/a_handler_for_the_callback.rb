# frozen_string_literal: true

# RSpec example that tests [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks) handler methods
#
#     class Klass
#       include ActiveSupport::Callbacks
#
#       define_callback :kallback
#
#       def self.on_kallback(&block)
#         set_callback(:kallback, :after, &block)
#       end
#
#       def self.before_kallback(&block)
#         set_callback(:kallback, :before, &block)
#       end
#     end
#
#     RSpec.describe Klass do
#       include_context "with example class having callback", :kallback
#
#       subject(:instance) { Class.new(described_class).new }
#
#       it_behaves_like "a handler for the callback" do
#         let(:callback) { :kallback }
#       end
#
#       it_behaves_like "a handler for the callback" do
#         let(:callback) { :kallback }
#         let(:method) { :before_kallback }
#       end
#     end

RSpec.shared_examples_for "a handler for the callback" do
  subject(:run) { instance.run_callbacks(callback) }

  let(:method) { "on_#{callback}".to_sym }

  let(:instance) { test_class.new }
  let(:test_class) do
    Class.new(example_class).tap do |klass|
      klass.attr_accessor(:event_hook_run)
      klass.public_send(method) { self.event_hook_run = true }
    end
  end

  it "runs callback" do
    expect { run }.to change { instance.event_hook_run }.from(nil).to(true)
  end
end
