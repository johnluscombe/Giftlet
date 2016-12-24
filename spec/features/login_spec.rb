require_relative '../rails_helper'
require_relative '../support/login'

describe 'Login' do
  let!(:user) { FactoryGirl.create(:user) }

  subject { page }

  before { visit login_path }

  describe 'with blank username' do
    before do
      fill_in 'password', with: 'password'
      click_button 'Log In'
    end

    it 'produces an error message' do
      should have_css('div.alert')
    end

    it 'redirects to login page' do
      should have_current_path(login_path)
    end
  end

  describe 'with blank password' do
    before do
      fill_in 'username', with: user.username
      click_button 'Log In'
    end

    it 'produces an error message' do
      should have_css('div.alert')
    end

    it 'redirects to login page' do
      should have_current_path(login_path)
    end
  end

  describe 'with invalid username' do
    before do
      fill_in 'username', with: 'invalidusername'
      fill_in 'password', with: 'password'
      click_button 'Log In'
    end

    it 'produces an error message' do
      should have_css('div.alert')
    end

    it 'redirects to login page' do
      should have_current_path(login_path)
    end
  end

  describe 'with blank password' do
    before do
      fill_in 'username', with: user.username
      fill_in 'password', with: 'invalidpassword'
      click_button 'Log In'
    end

    it 'produces an error message' do
      should have_css('div.alert')
    end

    it 'redirects to login page' do
      should have_current_path(login_path)
    end
  end

  describe 'with valid information' do
    before do
      fill_in 'username', with: user.username
      fill_in 'password', with: 'password'
      click_button 'Log In'
    end

    it 'redirects to users page' do
      should have_current_path(users_path)
    end
  end
end