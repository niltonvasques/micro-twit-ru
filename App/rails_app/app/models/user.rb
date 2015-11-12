# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string
#  email           :string
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string
#  remember_token  :string
#  admin           :boolean
#

class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship",
           dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { self.email.downcase! }
  before_save { self.active = true }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def deny
    # Usei raw sql por causa da restrição de alteração do has_secure_password
    ActiveRecord::Base.connection.execute("UPDATE users SET active = false WHERE id = #{self.id}")
  end

  def allow
    # Usei raw sql por causa da restrição de alteração do has_secure_password
    ActiveRecord::Base.connection.execute("UPDATE users SET active = true WHERE id = #{self.id}")
  end

  def authenticate(unencrypted_password)
    if self.active?
      super(unencrypted_password)
    else
      false
    end
  end

  private
    
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
