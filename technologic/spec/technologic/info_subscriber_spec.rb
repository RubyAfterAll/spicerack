# frozen_string_literal: true

RSpec.describe Technologic::InfoSubscriber do
  it_behaves_like "a subscriber for severity", :info
end
