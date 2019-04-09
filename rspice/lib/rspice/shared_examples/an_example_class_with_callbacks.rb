# frozen_string_literal: true

# RSpec shared example to spec a class with callbacks
#
# Usage:
#
# module Flow::Callbacks
#   extend ActiveSupport::Concern
#
#   included do
#     include ActiveSupport::Callbacks
#     define_callbacks :initialize, :trigger
#   end
# end
#
# RSpec.describe Flow::Callbacks, type: :module do
#   subject(:example_class) { Class.new.include described_class }
#
#   it { is_expected.to include_module ActiveSupport::Callbacks }
#
#   it_behaves_like "an example class with callbacks", described_class, %i[initialize trigger]
# end

RSpec.shared_examples_for "an example class with callbacks" do |callback_module, callbacks|
  subject(:example_class) { Class.new.include callback_module }

  it { is_expected.to include_module ActiveSupport::Callbacks }

  describe "__callbacks" do
    subject { example_class.__callbacks.keys }

    it { is_expected.to match_array Array.wrap(callbacks) }
  end
end
