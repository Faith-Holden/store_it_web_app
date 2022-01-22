class LocationAccess < ApplicationRecord
  belongs_to :location, dependent: :destroy
  belongs_to :access_group, dependent: :destroy

  
  # class << self
  #   def locations_in_group(access_group)
  #     where(access_group_id: access_group.id).pluck(:location_id)
  #   end
  # end
end
