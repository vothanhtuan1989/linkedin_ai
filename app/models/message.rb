class Message < ApplicationRecord
  # a message belongs to a conversation and a user
  # belongs_to :conversation
  # belongs_to :user
  
  # a message has a content attribute that is a text
  # a message has a user attribute that is a boolean
  # the user attribute indicates whether the message was sent by the user or the AI
  validates :content, presence: true
  validates :user, inclusion: { in: [true, false] }
end
  