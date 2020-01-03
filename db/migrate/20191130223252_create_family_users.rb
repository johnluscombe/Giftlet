class CreateFamilyUsers < ActiveRecord::Migration
  def change
    create_table :family_users do |t|
      t.references :family, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.boolean :is_family_admin, default: false
    end
  end
end
