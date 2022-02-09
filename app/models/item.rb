class Item < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}

  has_many :items_accesses, dependent: :destroy
  has_many :access_groups, through: :items_accesses

  has_many :item_locations, dependent: :destroy
  has_many :locations, through: :item_locations
   
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
  #   quantity = 0
  #   self.item_locations.each do |il|
  #     quantity += il.quantity unless il.quantity.nil?
  #   end
  #   return quantity
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
