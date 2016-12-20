require_relative '../rails_helper'
require_relative '../support/login'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:username) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:fullname) }
  it { should respond_to(:unpurchased_gifts) }
  it { should respond_to(:amount_spent_on) }
  it { should respond_to(:gifts) }

  it { should be_valid }

  describe 'empty first name' do
    before { user.first_name = '' }

    it { should_not be_valid }
  end

  describe 'empty last name' do
    before { user.last_name = '' }

    it { should_not be_valid }
  end

  describe 'empty username' do
    before { user.username = '' }

    it { should_not be_valid }
  end

  describe 'empty password digest' do
    before { user.password_digest = '' }

    it { should_not be_valid }
  end

  describe 'duplicate username' do
    let(:duplicate) do
      d = user.dup
      d.first_name = 'first_name'
      d.last_name = 'last_name'
      d
    end

    it 'is not allowed' do
      expect(duplicate).not_to be_valid
    end
  end
end