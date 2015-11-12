class AddActiveToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :active, :boolean, default: true
  end
end
