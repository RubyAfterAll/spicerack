# frozen_string_literal: true

RSpec.describe Technologic::ErrorSubscriber do
  it_behaves_like "a subscriber for severity", :error
end
