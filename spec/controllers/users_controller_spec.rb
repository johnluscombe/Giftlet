require_relative '../rails_helper'
require_relative '../support/environment'
require_relative '../support/login'
require_relative '../support/other'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }

  subject { response }

  describe 'GET #index' do
    describe 'user not logged in' do
      it 'redirects to login page' do
        get :index
        should redirect_to(login_path)
      end
    end

    describe 'user logged in' do
      it 'renders :index template' do
        direct_login(user)
        get :index
        should render_template(:index)
      end
    end
  end

  describe 'GET #new' do
    describe 'without site passcode' do
      before { unset_env('SITE_PASSCODE') }

      describe 'user not logged in' do
        it 'redirects to login page' do
          get :new
          should redirect_to(login_path)
        end
      end

      describe 'user logged in' do
        it 'redirects to users page' do
          direct_login(user)
          get :new
          should redirect_to(users_path)
        end
      end
    end

    describe 'with site passcode' do
      before { set_env('SITE_PASSCODE', 'test') }

      describe 'user not logged in' do
        it 'renders :new template' do
          get :new
          should render_template(:new)
        end
      end

      describe 'user logged in' do
        it 'redirects to users page' do
          direct_login(user)
          get :new
          should redirect_to(users_path)
        end
      end
    end
  end

  describe 'POST #create' do
    describe 'without site passcode' do
      before { unset_env('SITE_PASSCODE') }

      describe 'user not logged in' do
        it 'does not create new user' do
          expect {
            post :create, user: { first_name: 'New',
                                  last_name: 'User',
                                  username: 'newusername',
                                  password: 'password',
                                  password_confirmation: 'password'
            }
          }.to_not change(User, :count)
        end

        it 'redirects to login page' do
          post :create, user: { first_name: 'New',
                                last_name: 'User',
                                username: 'newusername',
                                password: 'password',
                                password_confirmation: 'password'
          }
          expect(response).to redirect_to(login_path)
        end
      end

      describe 'user logged in' do
        before { direct_login(user) }

        it 'does not create new user' do
          expect {
            post :create, user: { first_name: 'New',
                                  last_name: 'User',
                                  username: 'newusername',
                                  password: 'password',
                                  password_confirmation: 'password'
            }
          }.to_not change(User, :count)
        end

        it 'redirects to users page' do
          post :create, user: { first_name: 'New',
                                last_name: 'User',
                                username: 'newusername',
                                password: 'password',
                                password_confirmation: 'password'
          }
          expect(response).to redirect_to(users_path)
        end
      end
    end

    describe 'with site passcode' do
      before { set_env('SITE_PASSCODE', 'test') }

      describe 'user not logged in' do
        it 'creates new user' do
          expect {
            post :create, site_passcode: 'test', user: { first_name: 'New',
                                                         last_name: 'User',
                                                         username: 'newusername',
                                                         password: 'password',
                                                         password_confirmation: 'password'
            }
          }.to change(User, :count).by(1)
        end

        it 'redirects to login page' do
          post :create, site_passcode: 'test', user: { first_name: 'New',
                                                       last_name: 'User',
                                                       username: 'newusername',
                                                       password: 'password',
                                                       password_confirmation: 'password'
          }
          expect(response).to redirect_to(login_path)
        end
      end

      describe 'user logged in' do
        before { direct_login(user) }

        it 'does not create new user' do
          expect {
            post :create, site_passcode: 'test', user: { first_name: 'New',
                                                         last_name: 'User',
                                                         username: 'newusername',
                                                         password: 'password',
                                                         password_confirmation: 'password'
            }
          }.to_not change(User, :count)
        end

        it 'redirects to users page' do
          post :create, site_passcode: 'test', user: { first_name: 'New',
                                                       last_name: 'User',
                                                       username: 'newusername',
                                                       password: 'password',
                                                       password_confirmation: 'password'
          }
          expect(response).to redirect_to(users_path)
        end
      end
    end
  end

  describe 'GET #edit_basic_information' do
    describe 'user not logged in' do
      it 'redirects to login page' do
        get :edit_basic_information
        should redirect_to(login_path)
      end
    end

    describe 'user logged in' do
      it 'renders :edit_basic_information template' do
        direct_login(user)
        get :edit_basic_information
        should render_template(:edit_basic_information)
      end
    end
  end

  describe 'GET #edit_password' do
    describe 'user not logged in' do
      it 'redirects to login page' do
        get :edit_password
        should redirect_to(login_path)
      end
    end

    describe 'user logged in' do
      it 'renders :edit_password template' do
        direct_login(user)
        get :edit_password
        should render_template(:edit_password)
      end
    end
  end

  describe 'PATCH #update_basic_information' do
    let!(:new_user) { FactoryGirl.create(:user) }

    describe 'user not logged in' do
      it 'does not update user' do
        patch :update_basic_information, id: new_user, user: { username: 'newusername' }
        expect(new_user.reload.username).not_to eq('newusername')
      end

      it 'does not update user count' do
        expect {
          patch :update_basic_information, id: new_user, user: { username: 'newusername' }
        }.not_to change(User, :count)
      end

      it 'redirects to login page' do
        patch :update_basic_information, id: new_user, user: { username: 'newusername' }
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'user logged in' do
      before { direct_login(new_user) }

      it 'updates user' do
        patch :update_basic_information, id: new_user, user: { username: 'newusername' }
        expect(new_user.reload.username).to eq('newusername')
      end

      it 'does not update user count' do
        expect {
          patch :update_basic_information, id: new_user, user: { username: 'newusername' }
        }.not_to change(User, :count)
      end

      it 'redirects to edit basic information page' do
        patch :update_basic_information, id: new_user, user: { username: 'newusername' }
        expect(response).to redirect_to(edit_basic_information_path)
      end
    end
  end

  describe 'PATCH #update_password' do
    let!(:new_user) { FactoryGirl.create(:user) }

    describe 'user not logged in' do
      it 'does not update user' do
        patch :update_password, id: new_user, old_password: 'password', user: { password: 'newpassword',
                                                                                password_confirmation: 'newpassword'}
        expect(bcrypt(new_user.reload.password_digest)).not_to eq('newpassword')
      end

      it 'does not update user count' do
        expect {
          patch :update_password, id: new_user, old_password: 'password', user: { password: 'newpassword',
                                                                                  password_confirmation: 'newpassword'}
        }.not_to change(User, :count)
      end

      it 'redirects to login page' do
        patch :update_password, id: new_user, old_password: 'password', user: { password: 'newpassword',
                                                                                password_confirmation: 'newpassword'}
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'user logged in' do
      before { direct_login(new_user) }

      it 'updates user' do
        patch :update_password, id: new_user, old_password: 'password', user: { password: 'newpassword',
                                                                                password_confirmation: 'newpassword'}
        expect(bcrypt(new_user.reload.password_digest)).to eq('newpassword')
      end

      it 'does not update user count' do
        expect {
          patch :update_password, id: new_user, old_password: 'password', user: { password: 'newpassword',
                                                                                  password_confirmation: 'newpassword'}
        }.not_to change(User, :count)
      end

      it 'redirects to users page' do
        patch :update_password, id: new_user, old_password: 'password', user: { password: 'newpassword',
                                                                                password_confirmation: 'newpassword'}
        expect(response).to redirect_to(users_path)
      end
    end
  end
end