class FamilyUser < ActiveRecord::Base
  belongs_to :family
  belongs_to :user

  validates :family, presence: true
  validates :user, presence: true
end
