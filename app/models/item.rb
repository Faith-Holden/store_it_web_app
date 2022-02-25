class Item < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size: { less_than: 5.megabytes,
                            message: "should be less than 5MB" }

  has_many :items_accesses, dependent: :destroy
  has_many :access_groups, through: :items_accesses

  has_many :item_locations, dependent: :destroy
  has_many :locations, through: :item_locations

  has_one_attached :image
   
  after_create :set_item_location

  def visible_locations(user)
    locations = Array.new
    user_locations = user.locations

    self.locations.each do |location|
      if user_locations.include?(location)
        locations << location
      end
    end
    locations = locations.uniq
  end

  def locationless?
    return ItemLocation.where(item_id: self.id).with_location.empty?
  end

  def add_to_location(location)
    self.locations << location
  end

  # def quantity
  # end

  def set_item_location(location= nil)
    if location.nil?
     location_id = nil
    else
      location_id=location.id
    end
    ItemLocation.new(item_id: self.id, location_id: location_id, quantity: 1).save
  end
  
  
end
