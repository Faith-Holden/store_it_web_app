class Item < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}

  has_many :item_locations
  has_many :locations, through: :item_locations
   


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
