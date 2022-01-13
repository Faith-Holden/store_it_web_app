class User < ApplicationRecord
  attr_accessor :activation_token


  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                   length: {maximum: 100},
                   format: {with: VALID_EMAIL_REGEX},
                   uniqueness: true
  validates :password, presence: true, length: { minimum: 6}, allow_nil: true


  before_save :downcase_email
  before_create :create_activation_digest
  has_secure_password
  



  # has_many organizations
  # has_many access_groups




  def activate
    update_attribute(:activated, true)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    
    BCrypt::Password.new(digest).is_password?(token)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private
    def downcase_email
      email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end

end
