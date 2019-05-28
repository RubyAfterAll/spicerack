# frozen_string_literal: true

RSpec.describe Ascriptor::Base, type: :ascriptor do
  subject { described_class }

  it { is_expected.to inherit_from RootObject::Base }
end
