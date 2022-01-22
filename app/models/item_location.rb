class ItemLocation < ApplicationRecord
  belongs_to :item, dependent: :destroy
  belongs_to :location, dependent: :destroy


end
