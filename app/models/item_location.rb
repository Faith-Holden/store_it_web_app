class ItemLocation < ApplicationRecord
  belongs_to :item
  belongs_to :location
  scope :locationless, -> {where(location_id: [nil, ""])}
  scope :with_location, -> { where("location_id <> ''")}

  before_create :set_initial_quantity

  def increment_quantity(increase=1)
    self.update_attribute(:quantity, self.quantity+increase)
  end

  def decrement_quantity(decrease=1)
    self.update_attribute(:quantity, self.quantity-decrease)
  end

  private
    def set_initial_quantity
      self.quantity ||=1
    end
end
