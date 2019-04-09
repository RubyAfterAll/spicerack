# frozen_string_literal: true

RSpec.configure do |config|
  config.before { allow(ActiveSupport::Notifications).to receive(:instrument).and_call_original }
end
