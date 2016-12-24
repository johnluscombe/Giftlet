require_relative '../rails_helper'
require_relative '../support/login'

describe LoginsController do
  let!(:user) { FactoryGirl.create(:user) }

  subject { response }

  describe 'GET #new' do
    describe 'user already logged in' do
      before { direct_login user }

      it 'redirects to users page' do
        get :new
        should redirect_to(users_path)
      end
    end

    describe 'user not logged in' do
      it 'renders :new template' do
        get :new
        should render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    describe 'with blank username' do
      before do
        post :create, username: '', password: 'password'
      end

      it 'does not log the user in' do
        expect(current_user).to be(nil)
      end

      it 'renders :new template' do
        should render_template(:new)
      end
    end

    describe 'with blank password' do
      before do
        post :create, username: user.username, password: ''
      end

      it 'does not log the user in' do
        expect(current_user).to be(nil)
      end

      it 'renders :new template' do
        should render_template(:new)
      end
    end

    describe 'with invalid username' do
      before do
        post :create, username: 'invalidusername', password: 'password'
      end

      it 'does not log the user in' do
        expect(current_user).to be(nil)
      end

      it 'renders :new template' do
        should render_template(:new)
      end
    end

    describe 'with invalid password' do
      before do
        post :create, username: user.username, password: 'invalidpassword'
      end

      it 'does not log the user in' do
        expect(current_user).to be(nil)
      end

      it 'renders :new template' do
        should render_template(:new)
      end
    end

    describe 'with valid information' do
      before do
        post :create, username: user.username, password: 'password'
      end

      it 'logs the user in' do
        expect(current_user).to eq(user)
      end

      it 'renders users :index template' do
        should redirect_to(users_path)
      end
    end
  end
end