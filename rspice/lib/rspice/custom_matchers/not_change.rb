# frozen_string_literal: true

# RSpec matcher that tests that an object does not change.
# Because of how RSpec's `change` matcher works, this is required
# to chain multiple negated change matchers.
#
#     def noop
#       # I don't do anything!
#     end
#
#     describe "#noop" do
#       it "doesn't change anything in the database" do
#         expect { noop }.
#           not_to change { User.count }.
#           and not_change { Article.count }
#       end
#     end

RSpec::Matchers.define_negated_matcher(:not_change, :change)
