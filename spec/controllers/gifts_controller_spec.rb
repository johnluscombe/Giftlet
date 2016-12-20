require_relative '../rails_helper'
require_relative '../support/login'

describe GiftsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:gift) { FactoryGirl.create(:gift, user: user) }

  subject { response }

  describe 'GET #index' do
    describe 'user not logged in' do
      it 'redirects to login page' do
        get :index, user_id: user
        should redirect_to(login_path)
      end
    end

    describe 'viewing gifts of other user' do
      it 'renders :index template' do
        direct_login(user)
        get :index, user_id: other_user
        should render_template(:index)
      end
    end

    describe 'viewing own gifts' do
      it 'renders :index template' do
        direct_login(user)
        get :index, user_id: user
        should render_template(:index)
      end
    end
  end

  describe 'GET #new' do
    describe 'user not logged in' do
      it 'redirects to login page' do
        get :new, user_id: user
        should redirect_to(login_path)
      end
    end

    describe 'wrong user logged in' do
      it 'redirects to users page' do
        direct_login(user)
        get :new, user_id: other_user
        should redirect_to(users_path)
      end
    end

    describe 'user logged in' do
      it 'renders :new template' do
        direct_login(user)
        get :new, user_id: user
        should render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    describe 'user not logged in' do
      it 'does not create new gift' do
        expect {
          post :create, user_id: user, gift: { name: 'New Gift' }
        }.to_not change(Gift, :count)
      end

      it 'redirects to login page' do
        post :create, user_id: user, gift: { name: 'New Gift' }
        should redirect_to(login_path)
      end
    end

    describe 'wrong user logged in' do
      before { direct_login(user) }

      it 'does not create new gift' do
        expect {
          post :create, user_id: other_user, gift: { name: 'New Gift' }
        }.to_not change(Gift, :count)
      end

      it 'redirects to users page' do
        post :create, user_id: other_user, gift: { name: 'New Gift' }
        should redirect_to(users_path)
      end
    end

    describe 'user logged in' do
      before { direct_login(user) }

      it 'creates new gift' do
        expect {
          post :create, user_id: user, gift: { name: 'New Gift' }
        }.to change(Gift, :count).by(1)
      end

      it 'redirects to user gifts page' do
        post :create, user_id: user, gift: { name: 'New Gift' }
        should redirect_to(user_gifts_path(user))
      end
    end
  end

  describe 'GET #edit' do
    describe 'user not logged in' do
      it 'redirects to login page' do
        get :edit, id: gift
        should redirect_to(login_path)
      end
    end

    describe 'wrong user logged in' do
      it 'redirects to users page' do
        direct_login(other_user)
        get :edit, id: gift
        should redirect_to(users_path)
      end
    end

    describe 'user logged in' do
      it 'renders :edit template' do
        direct_login(user)
        get :edit, id: gift
        should render_template(:edit)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:new_gift) { FactoryGirl.create(:gift, user: user) }
    describe 'user not logged in' do
      it 'does not update gift' do
        patch :update, id: new_gift, gift: { name: 'New Name' }
        expect(new_gift.reload.name).not_to eq('New Name')
      end

      it 'does not update gift count' do
        expect {
          patch :update, id: new_gift, gift: { name: 'New Name' }
        }.not_to change(Gift, :count)
      end

      it 'redirects to login page' do
        patch :update, id: new_gift, gift: { name: 'New Name' }
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'wrong user logged in' do
      before { direct_login(other_user) }

      it 'does not update gift' do
        patch :update, id: new_gift, gift: { name: 'New Name' }
        expect(new_gift.reload.name).not_to eq('New Name')
      end

      it 'does not update gift count' do
        expect {
          patch :update, id: new_gift, gift: { name: 'New Name' }
        }.not_to change(Gift, :count)
      end

      it 'redirects to users page' do
        patch :update, id: new_gift, gift: { name: 'New Name' }
        expect(response).to redirect_to(users_path)
      end
    end

    describe 'user logged in' do
      before { direct_login(user) }

      it 'updates gift' do
        patch :update, id: new_gift, gift: { name: 'New Name' }
        expect(new_gift.reload.name).to eq('New Name')
      end

      it 'does not update gift count' do
        expect {
          patch :update, id: new_gift, gift: { name: 'New Name' }
        }.not_to change(Gift, :count)
      end

      it 'redirects to user gifts page' do
        patch :update, id: new_gift, gift: { name: 'New Name' }
        expect(response).to redirect_to(user_gifts_path(user))
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:new_gift) { FactoryGirl.create(:gift, user: user) }

    describe 'user not logged in' do
      it 'does not delete gift' do
        expect {
          delete :destroy, id: new_gift
        }.to_not change(Gift, :count)
      end

      it 'redirects to login page' do
        delete :destroy, id: new_gift
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'wrong user logged in' do
      before { direct_login(other_user) }

      it 'does not delete gift' do
        expect {
          delete :destroy, id: new_gift
        }.to_not change(Gift, :count)
      end

      it 'redirects to users page' do
        delete :destroy, id: new_gift
        expect(response).to redirect_to(users_path)
      end
    end

    describe 'user logged in' do
      before { direct_login(user) }

      it 'deletes gift' do
        expect {
          delete :destroy, id: new_gift
        }.to change(Gift, :count).by(-1)
      end

      it 'redirects to user gifts page' do
        delete :destroy, id: new_gift
        expect(response).to redirect_to(user_gifts_path(user))
      end
    end
  end
end