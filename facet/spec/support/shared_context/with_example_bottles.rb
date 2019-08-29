# frozen_string_literal: true

RSpec.shared_context "with example bottles" do
  include_context "with a bottles active record"

  before { Array.new(6) { |index| Bottle.create!(broken: index.even?) } }
end
