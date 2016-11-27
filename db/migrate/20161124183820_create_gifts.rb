class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :name
      t.string :description
      t.string :url
      t.float :price
      t.boolean :purchased
      t.date :date_purchased
      t.references :user
    end
  end
end
