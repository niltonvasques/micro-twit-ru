class Dislike < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :user

  validates :micropost_id, presence: true
  validates :user_id, presence: true
end
