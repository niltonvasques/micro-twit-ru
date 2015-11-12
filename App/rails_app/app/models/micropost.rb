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

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

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
end

