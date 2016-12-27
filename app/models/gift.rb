class Gift < ActiveRecord::Base
  belongs_to :user, inverse_of: :gifts

  validates :user, presence: true
  validates :name, presence: true
  validates :price, numericality: true, allow_nil: true
  validate :purchaser_not_self

  before_save :change_zero_price_to_nil

  def full_url
    if self.url[0..6] == 'http://' or self.url[0..7] == 'https://'
      self.url
    else
      'http://' + self.url
    end
  end

  def price_as_dollars
    if self.price.nil?
      nil
    else
      sprintf('%.2f', self.price)
    end
  end

  def price_as_dollars=(value)
    self.price = value
    self.save
  end

  def purchaser
    User.find(self.purchaser_id)
  end

  def purchaser=(user)
    self.purchaser_id = user.id
  end

  def change_zero_price_to_nil
    if self.price == 0.0
      self.price = nil
    end
  end

  def purchaser_not_self
    if self.user_id == self.purchaser_id
      errors.add(:purchaser, 'cannot be the gift recipient')
    end
  end
end