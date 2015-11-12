class CreateDislikes < ActiveRecord::Migration
  def change
    create_table :dislikes do |t|
      t.references :micropost, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :dislikes, :microposts
    add_foreign_key :dislikes, :users
    add_index :dislikes, [:user_id, :micropost_id], unique: true
  end
end
