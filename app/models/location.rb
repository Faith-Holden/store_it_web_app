class Location < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}

  has_many :item_locations
  has_many :items, through: :item_locations

  has_many :location_accesses
  has_many :access_groups, through: :location_accesses

  scope :child_locations, ->(parent){ where(parent_id: parent.id) }

end
