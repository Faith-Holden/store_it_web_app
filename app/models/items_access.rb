class ItemsAccess < ApplicationRecord
  belongs_to :access_group, dependent: :destroy
  belongs_to :item, dependent: :destroy

end
