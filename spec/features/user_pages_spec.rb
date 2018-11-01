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

      it 'lists all recipients' do
        User.all.each do |other_user|
          within(:css, '.sidebar') do
            should have_content(other_user.fullname)
          end
        end
      end
    end
  end

  describe 'creating new account' do
    let(:submit) { 'CREATE ACCOUNT' }
    let(:cancel) { 'CANCEL' }

    before do
      set_env('ENABLE_SIGN_UP', 'true')
      visit login_path
      first('.btn', text: 'Sign Up').click
    end

    describe 'with invalid first name' do
      before do
        fill_in 'user_last_name', with: 'Last'
        fill_in 'user_username', with: 'firstlast'
        fill_in 'user_password', with: 'test'
        fill_in 'user_password_confirmation', with: 'test'
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

  describe 'editing basic information' do
    let(:submit) { 'UPDATE' }

    describe 'when logged in' do
      before do
        login user
        find('.dropdown-item', text: 'Edit Basic Information').click
      end

      describe 'with invalid first name' do
        before { fill_in 'user_first_name', with: '' }

        it 'does not change the data' do
          within(:css, '#editBasicInfoModal') do
            click_button submit
          end

          expect(user.first_name).to eq(user.reload.first_name)
        end

        it 'does not add a new user to the system' do
          expect do
            within(:css, '#editBasicInfoModal') do
              click_button submit
            end
          end.not_to change(User, :count)
        end
      end

      describe 'with invalid last name' do
        before { fill_in 'user_last_name', with: '' }

        it 'does not change the data' do
          within(:css, '#editBasicInfoModal') do
            click_button submit
          end

          expect(user.last_name).to eq(user.reload.last_name)
        end

        it 'does not add a new user to the system' do
          expect do
            within(:css, '#editBasicInfoModal') do
              click_button submit
            end
          end.not_to change(User, :count)
        end
      end

      describe 'with invalid username' do
        before { fill_in 'user_username', with: '' }

        it 'does not change the data' do
          within(:css, '#editBasicInfoModal') do
            click_button submit
          end

          expect(user.username).to eq(user.reload.username)
        end

        it 'does not add a new user to the system' do
          expect do
            within(:css, '#editBasicInfoModal') do
              click_button submit
            end
          end.not_to change(User, :count)
        end
      end

      describe 'with duplicate username' do
        let(:new_user) { FactoryGirl.create(:user) }

        before { fill_in 'user_username', with: new_user.username }

        it 'does not change the data' do
          within(:css, '#editBasicInfoModal') do
            click_button submit
          end

          expect(user.username).to eq(user.reload.username)
        end

        it 'does not add a new user to the system' do
          expect do
            within(:css, '#editBasicInfoModal') do
              click_button submit
            end
          end.not_to change(User, :count)
        end

        it 'produces an error message' do
          within(:css, '#editBasicInfoModal') do
            click_button submit
          end

          should have_css('div.alert')
        end
      end

      describe 'with valid information' do
        before { fill_in 'user_username', with: 'newusername' }

        it 'changes the data' do
          within(:css, '#editBasicInfoModal') do
            click_button submit
          end

          expect(user.username).not_to eq(user.reload.username)
        end

        it 'does not add a new user to the system' do
          expect do
            within(:css, '#editBasicInfoModal') do
              click_button submit
            end
          end.not_to change(User, :count)
        end

        it 'redirects to previous page' do
          within(:css, '#editBasicInfoModal') do
            click_button submit
          end

          should have_current_path(users_path)
        end
      end
    end
  end
end