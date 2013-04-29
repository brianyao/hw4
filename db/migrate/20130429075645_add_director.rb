class AddDirector < ActiveRecord::Migration
  def up
    change_table :movies do |entry|
      entry.string :director
  	end
  end

  def down
  	remove_column :movies, :director
  end
end
