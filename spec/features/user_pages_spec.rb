require_relative '../rails_helper'
require_relative '../support/environment'
require_relative '../support/login'

describe 'User Pages' do
  let(:user) { FactoryGirl.create(:user) }

  subject { page }

  describe 'viewing list of recipients' do
    before { 10.times { FactoryGirl.create(:user) } }

    it 'has 10 recipients'

    describe 'when not logged in' do
      it 'redirects to login page'
    end

    describe 'when logged in' do
      before { login_user }

      it 'lists the other recipients'

      it 'does not list the current user'
    end
  end

  describe 'creating new account' do
    describe 'already logged in' do
      before { login user }

      it 'redirects to users page'
    end

    describe 'without site passcode' do
      before do
        unset_env('SITE_PASSCODE')
        visit login_path
        click_link 'Create New Account'
      end

      it 'does not allow access'

      it 'redirects to login page'

      it 'shows error message'
    end

    describe 'with site passcode' do
      before do
        set_env('SITE_PASSCODE', 'test')
        visit login_path
        click_link 'Create New Account'
      end

      it 'allows access'

      describe 'with invalid first name' do
        it 'does not add the user to the system'

        it 'produces an error message'

        it 're-renders the new view'
      end

      describe 'with invalid last name' do
        it 'does not add the user to the system'

        it 'produces an error message'

        it 're-renders the new view'
      end

      describe 'with invalid username' do
        it 'does not add the user to the system'

        it 'produces an error message'

        it 're-renders the new view'
      end

      describe 'with duplicate username' do
        it 'does not add the user to the system'

        it 'produces an error message'

        it 're-renders the new view'
      end

      describe 'with invalid password' do
        it 'does not add the user to the system'

        it 'produces an error message'

        it 're-renders the new view'
      end

      describe 'with invalid password confirmation' do
        it 'does not add the user to the system'

        it 'produces an error message'

        it 're-renders the new view'
      end

      describe 'with password and confirmation not matching' do
        it 'does not add the user to the system'

        it 'produces an error message'

        it 're-renders the new view'
      end

      describe 'with valid information' do
        it 'adds the user to the system'

        it 'redirects to login page'
      end

      describe 'clicking cancel' do
        it 'does not add the user to the system'

        it 'redirects to login page'
      end
    end
  end

  describe 'editing basic information' do
    describe 'when not logged in' do
      it 'redirects to login page'
    end

    describe 'when logged in' do
      before do
        login user
        click_link 'Edit Basic Information'
      end

      it 'allows access'

      describe 'with invalid first name' do
        it 'does not change the data'

        it 'does not add a new user to the system'

        it 'produces an error message'

        it 're-renders the edit basic information view'
      end

      describe 'with invalid last name' do
        it 'does not change the data'

        it 'does not add a new user to the system'

        it 'produces an error message'

        it 're-renders the edit basic information view'
      end

      describe 'with invalid username' do
        it 'does not change the data'

        it 'does not add a new user to the system'

        it 'produces an error message'

        it 're-renders the edit basic information view'
      end

      describe 'with duplicate username' do
        it 'does not change the data'

        it 'does not add a new user to the system'

        it 'produces an error message'

        it 're-renders the edit basic information view'
      end

      describe 'with valid information' do
        it 'changes the data'

        it 'does not add a new user to the system'

        it 'redirects to edit basic information page'
      end

      describe 'clicking cancel' do
        it 'does not change the data'

        it 'does not add a new user to the system'

        it 'redirects to users page'
      end
    end
  end

  describe 'editing password' do
    describe 'when not logged in' do
      it 'redirects to login page'
    end

    describe 'when logged in' do
      before do
        login user
        click_link 'Edit Basic Information'
      end

      it 'allows access'

      describe 'with invalid old password' do
        it 'does not change the data'

        it 'does not add a new user to the system'

        it 'produces an error message'

        it 're-renders the edit password view'
      end

      describe 'with invalid password' do
        it 'does not change the data'

        it 'does not add a new user to the system'

        it 'produces an error message'

        it 're-renders the edit password view'
      end

      describe 'with invalid password confirmation' do
        it 'does not change the data'

        it 'does not add a new user to the system'

        it 'produces an error message'

        it 're-renders the edit password view'
      end

      describe 'with password and confirmation not matching' do
        it 'does not change the data'

        it 'does not add a new user to the system'

        it 'produces an error message'

        it 're-renders the edit password view'
      end

      describe 'with valid information' do
        it 'changes the data'

        it 'does not add a new user to the system'

        it 'redirects to users page'
      end

      describe 'clicking cancel' do
        it 'does not change the data'

        it 'does not add a new user to the system'

        it 'redirects to users page'
      end
    end
  end
end