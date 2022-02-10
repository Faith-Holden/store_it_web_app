class ItemLocation < ApplicationRecord
  belongs_to :item
  belongs_to :location
  scope :locationless, -> {where(location_id: [nil, ""])}
  scope :with_location, -> { where("location_id <> ''")}

end
