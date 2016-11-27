class Gift < ActiveRecord::Base
  belongs_to :user, inverse_of: :gifts

  validates :name, presence: true
  validates :price, numericality: true

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
end