class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}

  # has_many organizations
  # has_many access_groups
  # ?has_many items?

end
