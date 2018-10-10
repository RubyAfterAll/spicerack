# frozen_string_literal: true

RSpec.describe Technologic::FatalSubscriber do
  it_behaves_like "a subscriber for severity", :fatal
end
