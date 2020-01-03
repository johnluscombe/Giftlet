class User < ActiveRecord::Base
  has_many :family_users
  has_many :families, through: :family_users
  has_many :gifts, inverse_of: :user

  before_destroy { self.gifts.destroy_all }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_secure_password

  def fullname
    self.first_name + ' ' + self.last_name
  end

  def can_view_family_gifts?(family)
    self.part_of_family?(family) or self.site_admin?
  end

  def can_edit_family_gifts?(family)
    self.family_admin?(family) or self.site_admin?
  end

  def can_clear_purchased_for?(gifts_user)
    is_site_admin = self.site_admin?
    not_gifts_user = self != gifts_user
    purchased_to_clear = gifts_user.gifts.where.not(purchaser_id: nil).count > 0
    is_site_admin and not_gifts_user and purchased_to_clear
  end

  def part_of_family?(family)
    family.users.include?(self)
  end

  def family_admin?(family)
    family_user = self.family_users.find_by(family_id: family.id)
    family_user.nil? ? false : family_user.is_family_admin
  end

  def site_admin?
    self.is_site_admin
  end
end