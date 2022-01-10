class Location < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  validates :access_group_id, presence: true

  # belongs_to organization
  # belongs_to access_group
  # ?has_many organizations?

end
