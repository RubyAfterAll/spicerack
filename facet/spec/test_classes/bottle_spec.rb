# frozen_string_literal: true

RSpec.describe Bottle, type: :model do
  include_context "with a bottles active record"

  it { is_expected.to inherit_from ActiveRecord::Base }

  describe "#paginate" do
    subject { described_class.all.paginate(page: 1) }

    it { is_expected.to inherit_from ActiveRecord::Relation }
  end
end
