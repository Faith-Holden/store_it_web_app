class Item < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  validates :access_group_id, presence: true

  # belongs_to :location
  # belongs_to :accessgroup

  
end
