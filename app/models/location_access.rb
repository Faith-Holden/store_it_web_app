class LocationAccess < ApplicationRecord
  belongs_to :location, dependent: :destroy
  belongs_to :access_group, dependent: :destroy


end
