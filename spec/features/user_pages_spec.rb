require_relative '../rails_helper'
require_relative '../support/environment'
require_relative '../support/login'

describe 'User Pages' do
  let(:user) { FactoryGirl.create(:user) }

  subject { page }

  describe 'viewing list of recipients' do
    before { 10.times { FactoryGirl.create(:user) } }

    it 'has 10 recipients' do
      expect(User.count).to eq(10)
    end

    describe 'when not logged in' do
      before { visit users_path }

      it 'redirects to login page' do
        should have_current_path(login_path)
      end
    end

    describe 'when logged in' do
      before { login user }

      it 'allows access' do
        should have_current_path(users_path)
      end

      it 'lists the other recipients' do
        User.where.not(id: user.id).each do |other_user|
          within(:css, 'table') do
            should have_content(other_user.fullname)
          end
        end
      end

      it 'does not list the current user' do
        within(:css, 'table') do
          should_not have_content(user.fullname)
        end
      end
    end
  end

  describe 'creating new account' do
    describe 'already logged in' do
      before { login user }

      it 'redirects to users page' do
        visit new_user_path
        should have_current_path(users_path)
      end
    end

    describe 'without site passcode' do
      before do
        unset_env('SITE_PASSCODE')
        visit login_path
        click_link 'Create New Account'
      end

      it 'redirects to login page' do
        should have_current_path(login_path)
      end

      it 'shows error message' do
        should have_css('div.alert')
      end
    end

    describe 'with site passcode' do
      let(:submit) { 'CREATE ACCOUNT' }
      let(:cancel) { 'CANCEL' }

      before do
        set_env('SITE_PASSCODE', 'test')
        visit login_path
        click_link 'Create New Account'
      end

      it 'allows access' do
        should have_current_path(new_user_path)
      end

      describe 'with invalid first name' do
        before do
          fill_in 'user_last_name', with: 'Last'
          fill_in 'user_username', with: 'firstlast'
          fill_in 'user_password', with: 'test'
          fill_in 'user_password_confirmation', with: 'test'
          fill_in 'site_passcode', with: 'test'
        end

        it 'does not add the user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the new view' do
          click_button submit
          should have_content('New User')
        end
      end

      describe 'with invalid last name' do
        before do
          fill_in 'user_first_name', with: 'First'
          fill_in 'user_username', with: 'firstlast'
          fill_in 'user_password', with: 'test'
          fill_in 'user_password_confirmation', with: 'test'
          fill_in 'site_passcode', with: 'test'
        end

        it 'does not add the user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the new view' do
          click_button submit
          should have_content('New User')
        end
      end

      describe 'with invalid username' do
        before do
          fill_in 'user_first_name', with: 'First'
          fill_in 'user_last_name', with: 'Last'
          fill_in 'user_password', with: 'test'
          fill_in 'user_password_confirmation', with: 'test'
          fill_in 'site_passcode', with: 'test'
        end

        it 'does not add the user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the new view' do
          click_button submit
          should have_content('New User')
        end
      end

      describe 'with duplicate username' do
        let(:new_user) { FactoryGirl.create(:user) }

        before do
          fill_in 'user_first_name', with: 'First'
          fill_in 'user_last_name', with: 'Last'
          fill_in 'user_username', with: new_user.username
          fill_in 'user_password', with: 'test'
          fill_in 'user_password_confirmation', with: 'test'
          fill_in 'site_passcode', with: 'test'
        end

        it 'does not add the user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the new view' do
          click_button submit
          should have_content('New User')
        end
      end

      describe 'with invalid password' do
        before do
          fill_in 'user_first_name', with: 'First'
          fill_in 'user_last_name', with: 'Last'
          fill_in 'user_username', with: 'firstlast'
          fill_in 'user_password_confirmation', with: 'test'
          fill_in 'site_passcode', with: 'test'
        end

        it 'does not add the user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the new view' do
          click_button submit
          should have_content('New User')
        end
      end

      describe 'with invalid password confirmation' do
        before do
          fill_in 'user_first_name', with: 'First'
          fill_in 'user_last_name', with: 'Last'
          fill_in 'user_username', with: 'firstlast'
          fill_in 'user_password', with: 'test'
          fill_in 'site_passcode', with: 'test'
        end

        it 'does not add the user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the new view' do
          click_button submit
          should have_content('New User')
        end
      end

      describe 'with password and confirmation not matching' do
        before do
          fill_in 'user_first_name', with: 'Last'
          fill_in 'user_last_name', with: 'Last'
          fill_in 'user_username', with: 'firstlast'
          fill_in 'user_password', with: 'test1'
          fill_in 'user_password_confirmation', with: 'test2'
          fill_in 'site_passcode', with: 'test'
        end

        it 'does not add the user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the new view' do
          click_button submit
          should have_content('New User')
        end
      end

      describe 'with valid information' do
        before do
          fill_in 'user_first_name', with: 'Last'
          fill_in 'user_last_name', with: 'Last'
          fill_in 'user_username', with: 'firstlast'
          fill_in 'user_password', with: 'test'
          fill_in 'user_password_confirmation', with: 'test'
          fill_in 'site_passcode', with: 'test'
        end

        it 'adds the user to the system' do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        it 'redirects to login page' do
          click_button submit
          should have_current_path(login_path)
        end
      end

      describe 'clicking cancel' do
        it 'does not add the user to the system' do
          expect { click_link cancel }.not_to change(User, :count)
        end

        it 'redirects to login page' do
          click_link cancel
          should have_current_path(login_path)
        end
      end
    end
  end

  describe 'editing basic information' do
    let(:submit) { 'UPDATE' }
    let(:cancel) { 'CANCEL' }

    describe 'when not logged in' do
      it 'redirects to login page' do
        visit edit_basic_information_path
        should have_current_path(login_path)
      end
    end

    describe 'when logged in' do
      before do
        login user
        click_link 'Edit Basic Information'
      end

      it 'allows access' do
        should have_current_path(edit_basic_information_path)
      end

      describe 'with invalid first name' do
        before { fill_in 'user_first_name', with: '' }

        it 'does not change the data' do
          click_button submit
          expect(user.first_name).to eq(user.reload.first_name)
        end

        it 'does not add a new user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 're-renders the edit basic information view' do
          click_button submit
          should have_content('Edit Basic Information')
        end
      end

      describe 'with invalid last name' do
        before { fill_in 'user_last_name', with: '' }

        it 'does not change the data' do
          click_button submit
          expect(user.last_name).to eq(user.reload.last_name)
        end

        it 'does not add a new user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 're-renders the edit basic information view' do
          click_button submit
          should have_content('Edit Basic Information')
        end
      end

      describe 'with invalid username' do
        before { fill_in 'user_username', with: '' }

        it 'does not change the data' do
          click_button submit
          expect(user.username).to eq(user.reload.username)
        end

        it 'does not add a new user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 're-renders the edit basic information view' do
          click_button submit
          should have_content('Edit Basic Information')
        end
      end

      describe 'with duplicate username' do
        let(:new_user) { FactoryGirl.create(:user) }

        before { fill_in 'user_username', with: new_user.username }

        it 'does not change the data' do
          click_button submit
          expect(user.username).to eq(user.reload.username)
        end

        it 'does not add a new user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the edit basic information view' do
          click_button submit
          should have_content('Edit Basic Information')
        end
      end

      describe 'with valid information' do
        before { fill_in 'user_username', with: 'newusername' }

        it 'changes the data' do
          click_button submit
          expect(user.username).not_to eq(user.reload.username)
        end

        it 'does not add a new user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'redirects to edit basic information page' do
          click_button submit
          should have_current_path(edit_basic_information_path)
        end
      end

      describe 'clicking cancel' do
        before { fill_in 'user_username', with: 'newusername' }

        it 'does not change the data' do
          click_link cancel
          expect(user.username).to eq(user.reload.username)
        end

        it 'does not add a new user to the system' do
          expect { click_link cancel }.not_to change(User, :count)
        end

        it 'redirects to users page' do
          click_link cancel
          should have_current_path(users_path)
        end
      end
    end
  end

  describe 'editing password' do
    describe 'when not logged in' do
      it 'redirects to login page' do
        visit edit_password_path
        should have_current_path(login_path)
      end
    end

    describe 'when logged in' do
      let(:submit) { 'UPDATE' }
      let(:cancel) { 'CANCEL' }

      before do
        login user
        click_link 'Change Password'
      end

      it 'allows access' do
        should have_current_path(edit_password_path)
      end

      describe 'with invalid old password' do
        before do
          fill_in 'old_password', with: 'invalidoldpassword'
          fill_in 'user_password', with: 'newpassword'
          fill_in 'user_password_confirmation', with: 'newpassword'
        end

        it 'does not change the data' do
          click_button submit
          expect(user.password_digest).to eq(user.reload.password_digest)
        end

        it 'does not add a new user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the edit password view' do
          click_button submit
          should have_content('Change Password')
        end
      end

      describe 'with invalid password' do
        before do
          fill_in 'old_password', with: 'password'
          fill_in 'user_password', with: ''
          fill_in 'user_password_confirmation', with: 'newpassword'
        end

        it 'does not change the data' do
          click_button submit
          expect(user.password_digest).to eq(user.reload.password_digest)
        end

        it 'does not add a new user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the edit password view' do
          click_button submit
          should have_content('Change Password')
        end
      end

      describe 'with invalid password confirmation' do
        before do
          fill_in 'old_password', with: 'password'
          fill_in 'user_password', with: 'newpassword'
          fill_in 'user_password_confirmation', with: ''
        end

        it 'does not change the data' do
          click_button submit
          expect(user.password_digest).to eq(user.reload.password_digest)
        end

        it 'does not add a new user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the edit password view' do
          click_button submit
          should have_content('Change Password')
        end
      end

      describe 'with password and confirmation not matching' do
        before do
          fill_in 'old_password', with: 'password'
          fill_in 'user_password', with: 'newpassword1'
          fill_in 'user_password_confirmation', with: 'newpassword2'
        end

        it 'does not change the data' do
          click_button submit
          expect(user.password_digest).to eq(user.reload.password_digest)
        end

        it 'does not add a new user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'produces an error message' do
          click_button submit
          should have_css('div.alert')
        end

        it 're-renders the edit password view' do
          click_button submit
          should have_content('Change Password')
        end
      end

      describe 'with valid information' do
        before do
          fill_in 'old_password', with: 'password'
          fill_in 'user_password', with: 'newpassword'
          fill_in 'user_password_confirmation', with: 'newpassword'
        end

        it 'changes the data' do
          click_button submit
          expect(user.password_digest).not_to eq(user.reload.password_digest)
        end

        it 'does not add a new user to the system' do
          expect { click_button submit }.not_to change(User, :count)
        end

        it 'redirects to users page' do
          click_button submit
          should have_current_path(users_path)
        end
      end

      describe 'clicking cancel' do
        before do
          fill_in 'user_password', with: 'newpassword'
          fill_in 'user_password_confirmation', with: 'newpassword'
        end

        it 'does not change the data' do
          click_link cancel
          expect(user.password_digest).to eq(user.reload.password_digest)
        end

        it 'does not add a new user to the system' do
          expect { click_link cancel }.not_to change(User, :count)
        end

        it 'redirects to users page' do
          click_link cancel
          should have_current_path(users_path)
        end
      end
    end
  end
end