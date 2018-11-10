require_relative '../rails_helper'
require_relative '../support/environment'
require_relative '../support/login'

describe 'Navbar' do
  let(:user) { FactoryBot.create(:user) }

  subject { page }

  describe 'when not logged in' do
    before { visit login_path }

    it 'has the proper content' do
      within(:css, 'nav.navbar') do
        should have_content('Giftlet')
        should have_content('BETA')
        should have_selector('a', text: 'Log In')
      end
    end

    describe 'without sign ups enabled' do
      before do
        unset_env('ENABLE_SIGN_UP')
        visit login_path
      end

      it 'does not have "Sign Up" link' do
        within(:css, 'nav.navbar') do
          should_not have_content('Sign Up')
        end
      end
    end

    describe 'with sign ups enabled' do
      before do
        set_env('ENABLE_SIGN_UP', 'true')
        visit login_path
      end

      it 'has "Sign Up" link' do
        within(:css, 'nav.navbar') do
          should have_content('Sign Up')
        end
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
          should have_content('Edit Basic Information')
          should have_content('Change Password')
          should have_link('About Giftlet', href: about_path)
          should have_link('Log Out', href: logout_path)
        end
      end
    end
  end
end