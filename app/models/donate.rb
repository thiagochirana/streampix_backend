class Donate < ApplicationRecord
  belongs_to :user, optional: true
  validates :nickname, presence: true, length: { in: 6..15 }
  validates :message, length: { in: 6..200 }
  scope :paids, -> { where.not(paid_at: nil) }
  scope :this_month, -> { where(paid_at: Time.current.beginning_of_month..Time.current.end_of_month) }

  scope :paids_this_month, -> { paids.this_month }
end
