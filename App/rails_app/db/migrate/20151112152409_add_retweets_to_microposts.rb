class AddRetweetsToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :retweets, :integer, default: 0
  end
end
