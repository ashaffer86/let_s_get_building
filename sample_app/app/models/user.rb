class User < ApplicationRecord
  #micropost association
  has_many :microposts, dependent:  :destroy
  #relationship associations
  has_many :active_relationships,  class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                     foreign_key: "followed_id",
                                     dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates(:name,  {presence: true, length: {maximum: 50}})
  validates(:email,
              {presence: true,
                length: {maximum: 255},
                format: {with: VALID_EMAIL_REGEX},
                uniqueness: {case_sensitive: false}})

  has_secure_password
  validates(:password, presence: true, length: {minimum: 6}, allow_nil: true)
  #Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
    #means the digest is equal to the token when converted to a digest
  end

  def activate
    self.update_columns(activated: true, activated_at: Time.zone.now)

  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(self.reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    Micropost.where("user_id = ?", id)
  end

  #Follow passed in user
  def follow(other_user)
    following << other_user
  end

  #unfollow passed in user
  def unfollow(other_user)
    following.delete(other_user)
  end

  #returns true if current user is following passed in user
  def following?(other_user)
    following.include?(other_user)
  end

  private
    #Converts email to all lower-case
    def downcase_email
      email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
