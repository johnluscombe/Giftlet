class RemovePurchasedFromGifts < ActiveRecord::Migration
  def change
    remove_column :gifts, :purchased, :boolean
  end
end
