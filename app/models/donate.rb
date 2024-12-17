class Donate < ApplicationRecord
  belongs_to :user, optional: true
end
