class CreatePreDefinedTweets < ActiveRecord::Migration
  def change
    create_table :pre_defined_tweets do |t|
      t.text :content

      t.timestamps null: false
    end
  end
end
