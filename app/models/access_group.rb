class AccessGroup < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}

  has_many :user_accesses
  has_many :users, through: :user_accesses

  has_many :location_accesses
  has_many :locations, through: :location_accesses


  class <<self 
    def with_user_visible_locations(user)
      UserAccess.has_user(user)
                .can_see_locations
                .pluck(:access_group_id)
                .map{|group_id| AccessGroup.find_by(id: group_id)}
    end

    def with_user_visible_items(user)
      UserAccess.has_user(user)
                .can_see_items
                .pluck(:access_group_id)
                .map{|group_id| AccessGroup.find_by(id: group_id)}
    end

    def with_user_visible_items_and_locations(user)
      UserAccess.has_user(user)
                .can_see_locations
                .can_see_items
                .pluck(:access_group_id)
                .map{|group_id| AccessGroup.find_by(id: group_id)}
    end
    
  end

end
