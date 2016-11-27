class AddPurchaserToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :purchaser_id, :integer
  end
end
