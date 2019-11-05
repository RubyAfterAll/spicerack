# frozen_string_literal: true

RSpec.describe Conjunction::Conjunctive, type: :conjunctive do
  include_context "with an example conjunctive"

  it { is_expected.to include_module Conjunction::Prototype }

  it { is_expected.to delegate_method(:conjugate).to(:class) }
  it { is_expected.to delegate_method(:conjugate!).to(:class) }

  describe ".conjugate" do
    it "needs specs"
  end

  describe ".conjugate!" do
    it "needs specs"
  end

  describe ".inherited" do
    it "needs specs"
  end

  describe ".conjunction_for" do
    it "needs specs"
  end

  describe ".conjoins" do
    it "needs specs"
  end
end
