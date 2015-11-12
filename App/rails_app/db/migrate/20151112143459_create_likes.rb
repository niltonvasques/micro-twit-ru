class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :micropost, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :likes, :microposts
    add_foreign_key :likes, :users
    add_index :likes, [:user_id, :micropost_id], unique: true
  end
end
