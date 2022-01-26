class Item < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}

  has_many :item_locations
  has_many :locations, through: :item_locations
   
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

  # def quantity
  #   quantity = 0
  #   self.item_locations.each do |il|
  #     quantity += il.quantity unless il.quantity.nil?
  #   end
  #   return quantity
  # end

  class << self
  
  end
  
end
