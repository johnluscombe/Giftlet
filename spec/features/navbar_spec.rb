require_relative '../rails_helper'
require_relative '../support/login'

describe 'Navbar' do
  let(:user) { FactoryGirl.create(:user) }

  subject { page }

  describe 'when not logged in' do
    before { visit login_path }

    it 'has the proper content' do
      within(:css, 'nav.navbar') do
        should have_content('Giftlet')
        should have_content('BETA')
        should have_content('You are not logged in')
      end
    end
  end

  describe 'when logged in' do
    before { login user }

    it 'has the proper content' do
      within(:css, 'nav.navbar') do
        should have_content('Giftlet')
        should have_content('BETA')

        within(:css, 'div.dropdown-menu') do
          should have_link('View Your Gifts', href: user_gifts_path(user))
          should have_link('Edit Basic Information', href: edit_basic_information_path)
          should have_link('Change Password', href: edit_password_path)
          should have_link('About Giftlet', href: about_path)
          should have_link('Log Out', href: logout_path)
        end
      end
    end
  end
end