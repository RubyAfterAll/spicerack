# frozen_string_literal: true

RSpec.describe Technologic::DebugSubscriber do
  it_behaves_like "a subscriber for severity", :debug
end
