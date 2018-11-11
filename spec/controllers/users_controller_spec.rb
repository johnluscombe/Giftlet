require_relative '../rails_helper'
require_relative '../support/environment'
require_relative '../support/login'
require_relative '../support/other'

describe UsersController do
  let(:user) { FactoryBot.create(:user) }

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

  describe 'POST #create' do
    describe 'without sign ups enabled' do
      before { unset_env('ENABLE_SIGN_UP') }

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

    describe 'with sign ups enabled' do
      before { set_env('ENABLE_SIGN_UP', 'true') }

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

  describe 'PATCH #update_basic_information' do
    let!(:new_user) { FactoryBot.create(:user) }

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

      it 'redirects to previous page' do
        patch :update_basic_information, id: new_user, user: { username: 'newusername' }
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'user logged in' do
      before do
        set_http_referer(login_path)
        direct_login(new_user)
      end

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
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'PATCH #update_password' do
    let!(:new_user) { FactoryBot.create(:user) }

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
      before do
        set_http_referer(login_path)
        direct_login(new_user)
      end

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

      it 'redirects to previous page' do
        patch :update_password, id: new_user, old_password: 'password', user: { password: 'newpassword',
                                                                                password_confirmation: 'newpassword'}
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'DELETE #clear_purchased_gifts' do
    let(:second_user) { FactoryBot.create(:user) }
    let(:admin) { FactoryBot.create(:admin_user) }

    before do
      2.times { FactoryBot.create(:gift, user: second_user, purchased: true) }
      2.times { FactoryBot.create(:gift, user: second_user, purchased: true, purchaser_id: admin.id) }
      2.times { FactoryBot.create(:gift, user: second_user) }
      2.times { FactoryBot.create(:gift, user: admin, purchased: true) }
      2.times { FactoryBot.create(:gift, user: user) }
      set_http_referer(users_path)
    end

    describe 'when not site-admin' do
      before { direct_login(user) }

      it 'does not clear any gifts' do
        expect {
          delete :clear_purchased_gifts, user_id: second_user
        }.not_to change(Gift, :count)
      end
    end

    describe 'when viewing own gifts' do
      before { direct_login(admin) }

      it 'does not clear any gifts' do
        expect {
          delete :clear_purchased_gifts, user_id: admin
        }.not_to change(Gift, :count)
      end
    end

    describe 'when there are no purchased gifts to clear' do
      before { direct_login(admin) }

      it 'does not clear any gifts' do
        expect {
          delete :clear_purchased_gifts, user_id: user
        }.not_to change(Gift, :count)
      end
    end

    describe 'when site admin, not viewing own gifts, and there are purchased gifts to clear' do
      before { direct_login(admin) }

      it 'clears purchased gifts' do
        expect {
          delete :clear_purchased_gifts, user_id: second_user
        }.to change(Gift, :count).by(-4)
      end
    end
  end
end