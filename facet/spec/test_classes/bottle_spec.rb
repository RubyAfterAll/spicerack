# frozen_string_literal: true

RSpec.describe Bottle, type: :model do
  include_context "with a bottles active record"

  it { is_expected.to inherit_from ActiveRecord::Base }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to define_enum_for(:status).with_values(on_the_wall: 0, taken_down: 1, passed_around: 2) }

  describe "#paginate" do
    subject { described_class.all.paginate(page: 1) }

    it { is_expected.to inherit_from ActiveRecord::Relation }
  end
end
