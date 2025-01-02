class Donate < ApplicationRecord
  belongs_to :user, optional: true
  scope :paids, -> { where.not(paid_at: nil) }
  scope :this_month, -> { where(paid_at: Time.current.beginning_of_month..Time.current.end_of_month) }

  scope :paids_this_month, -> { paids.this_month }
end
