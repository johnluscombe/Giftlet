class Family < ActiveRecord::Base
  has_many :family_users
  has_many :users, through: :family_users

  validates :name, presence: true
end
