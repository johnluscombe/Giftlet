class RemoveDatePurchasedFromGifts < ActiveRecord::Migration
  def change
    remove_column :gifts, :date_purchased, :date
  end
end
