# frozen_string_literal: true

RSpec.shared_context "with example bottles" do
  include_context "with a bottles active record"

  before { Bottle.create!(Bottle.statuses.keys.map { |s| [ { status: s, broken: true }, { status: s } ] }.flatten) }
end
