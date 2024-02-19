class Connection < ApplicationRecord
  validates :first_name, :last_name, :url, :connected_on, presence: true
end
