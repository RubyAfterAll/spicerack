# frozen_string_literal: true

class Bottle < ActiveRecord::Base
  self.per_page = 2

  enum status: { on_the_wall: 0, taken_down: 1, passed_around: 2 }

  scope :broken, -> { where(broken: true) }
  scope :unbroken, -> { where(broken: false) }

  scope :newest_first, -> { order(updated_at: :desc) }
end
