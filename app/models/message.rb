class Message < ApplicationRecord
  validates :content, presence: true
  validates :user, inclusion: { in: [true, false] }
end
  