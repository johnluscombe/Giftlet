class AddForeignKeyToGifts < ActiveRecord::Migration
  def change
    add_foreign_key :gifts, :users
    add_index :gifts, :user_id
  end
end
