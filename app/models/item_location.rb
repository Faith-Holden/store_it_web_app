class ItemLocation < ApplicationRecord
  belongs_to :item, dependent: :destroy
  belongs_to :location, dependent: :destroy

  scope :locationless, -> {where(location_id: [nil, ""])}
  scope :with_location, -> { where("location_id <> ''")}

end
