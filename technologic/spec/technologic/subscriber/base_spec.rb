# frozen_string_literal: true

RSpec.describe Technologic::Subscriber::Base do
  subject { described_class }

  it { is_expected.to include_module Technologic::Subscriber::Core }
  it { is_expected.to include_module Technologic::Subscriber::EventHandling }
end
