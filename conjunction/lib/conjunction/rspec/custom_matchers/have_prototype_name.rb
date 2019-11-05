# frozen_string_literal: true

# RSpec matcher that tests value of `.prototype_name`
#
#     class ApplicationRecord < ActiveRecord::Base
#       include Conjunction::Conjunctive
#     end
#
#     class ShippingAddress < ApplicationRecord; end
#
#     RSpec.describe ShippingAddress, type: :model do
#       it { is_expected.to have_prototype_name "ShippingAddress" }
#     end

RSpec::Matchers.define :have_prototype_name do |prototype_name|
  match { |subject| expect(subject.prototype_name).to eq prototype_name }
  description { "have prototype name `#{prototype_name}'" }
  failure_message { |subject| "expected #{subject} to have prototype name `#{prototype_name}'" }
end
