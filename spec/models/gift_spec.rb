require_relative '../rails_helper'
require_relative '../support/login'

describe Gift do
  let(:gift) { FactoryBot.create(:gift) }

  subject { gift }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:url) }
  it { should respond_to(:price) }
  it { should respond_to(:purchased) }
  it { should respond_to(:date_purchased) }
  it { should respond_to(:purchaser_id) }
  it { should respond_to(:user) }
  it { should respond_to(:full_url) }
  it { should respond_to(:price_as_dollars) }
  it { should respond_to(:purchaser) }
  it { should respond_to(:change_zero_price_to_nil) }

  it { should be_valid }

  describe 'required User relationship' do
    before { gift.user_id = nil }

    it { should_not be_valid }
  end

  describe 'empty name' do
    before { gift.name = '' }

    it { should_not be_valid }
  end

  describe 'accepts blank description' do
    before { gift.description = '' }

    it { should be_valid }
  end

  describe 'accepts blank url' do
    before { gift.url = '' }

    it { should be_valid }
  end

  describe 'accepts blank price' do
    before { gift.price = nil }

    it { should be_valid }
  end

  describe 'with zero price' do
    let(:free_gift) { FactoryBot.create(:free_gift) }

    it 'converts price to nil' do
      expect(free_gift.price).to be(nil)
    end
  end

  describe 'accepts blank date purchased' do
    before { gift.date_purchased = '' }

    it { should be_valid }
  end

  describe 'accepts blank purchaser' do
    before { gift.purchaser_id = nil }

    it { should be_valid }
  end

  describe 'does not allow purchaser to be gift recipient' do
    before { gift.purchaser_id = gift.user_id }

    it { should_not be_valid }
  end

  describe 'accepts duplicate gifts' do
    let(:duplicate) do
      d = gift.dup
      d
    end

    it 'is allowed' do
      expect(duplicate).to be_valid
    end
  end
end