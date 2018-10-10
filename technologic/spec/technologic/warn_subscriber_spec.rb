# frozen_string_literal: true

RSpec.describe Technologic::WarnSubscriber do
  it_behaves_like "a subscriber for severity", :warn
end
