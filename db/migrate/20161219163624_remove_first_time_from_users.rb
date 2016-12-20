class RemoveFirstTimeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :first_time, :boolean
  end
end
