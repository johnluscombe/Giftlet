class User < ActiveRecord::Base
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

  def unpurchased_gifts
    self.gifts.where(purchased: [false, nil])
  end

  def site_admin?
    self.is_site_admin
  end
end