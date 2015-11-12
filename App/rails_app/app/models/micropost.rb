# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Micropost < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  belongs_to :user
  has_many :likes_from_users, class_name: "Like", dependent: :destroy
  has_many :dislikes_from_users, class_name: "Dislike", dependent: :destroy

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  validates :likes, length: { minimum: 0 }
  validates :dislikes, length: { minimum: 0 }

  default_scope { order(created_at: :desc) }

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships 
                          WHERE follower_id = :user_id" 
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
           user_id: user)
  end

  def deny
    self.active = false
    self.save
  end 

  def allow
    self.active = true 
    self.save
  end

  def like(user)
    if self.likes_from_users.where(user_id: user.id).empty?
      self.likes_from_users.create!(user_id: user.id)
      self.likes += 1 
    else
      self.likes_from_users.where(user_id: user.id).first.destroy!
      self.likes -= 1 
    end
    self.save
  end 

  def dislike(user)
    if self.dislikes_from_users.where(user_id: user.id).empty?
      self.dislikes_from_users.create!(user_id: user.id)
      self.dislikes += 1 
    else
      self.dislikes_from_users.where(user_id: user.id).first.destroy!
      self.dislikes -= 1 
    end
    self.save
  end
end

