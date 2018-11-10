require_relative '../rails_helper'
require_relative '../support/login'

describe LoginsHelper do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'not logged in' do
    it 'expects current_user to be nil' do
      expect(current_user).to eq(nil)
    end

    it 'expects current_user?(user) to be false' do
      expect(current_user?(user)).to eq(false)
    end

    it 'expects logged_in? to be false' do
      expect(logged_in?).to eq(false)
    end
  end

  describe 'logged in' do
    before { direct_login(user) }

    it 'expects current_user to be user' do
      expect(current_user).to eq(user)
    end

    it 'expects current_user?(user) to be true' do
      expect(current_user?(user)).to eq(true)
    end

    it 'expects current_user?(other_user) to be false' do
      expect(current_user?(other_user)).to eq(false)
    end

    it 'expects logged_in? to be true' do
      expect(logged_in?).to eq(true)
    end
  end
end