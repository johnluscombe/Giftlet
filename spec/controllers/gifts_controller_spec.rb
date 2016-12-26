require_relative '../rails_helper'
require_relative '../support/login'
require_relative '../support/environment'

describe GiftsController do
  render_views

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:third_user) { FactoryGirl.create(:user) }
  let(:gift) { FactoryGirl.create(:gift, user: user) }
  let(:other_user_gift) { FactoryGirl.create(:gift, user: other_user) }

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

    describe 'render_new' do
      describe 'user not logged in' do
        it 'redirects to login page' do
          get :index, user_id: user, render_new: true
          should redirect_to(login_path)
        end
      end

      describe 'other user' do
        it 'does not render new gift form' do
          direct_login(user)
          get :index, user_id: other_user, render_new: true
          should_not render_template(partial: '_new')
        end
      end

      describe 'correct user' do
        it 'renders new gift form' do
          direct_login(user)
          get :index, user_id: user, render_new: true
          should render_template(partial: '_new')
        end
      end
    end

    describe 'render_edit' do
      describe 'user not logged in' do
        it 'redirects to login page' do
          get :index, user_id: user, render_edit: gift.id
          should redirect_to(login_path)
        end
      end

      describe 'other user' do
        it 'does not render edit gift form' do
          direct_login(user)
          get :index, user_id: other_user, render_edit: other_user_gift.id
          should_not render_template(partial: '_edit')
        end
      end

      describe 'correct user' do
        it 'renders edit gift form' do
          direct_login(user)
          get :index, user_id: user, render_edit: gift.id
          should render_template(partial: '_edit')
        end
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
      before do
        direct_login(user)
        set_http_referer(user_gifts_path(user, render_new: true))
      end

      it 'creates new gift' do
        expect {
          post :create, user_id: user, gift: { name: 'New Gift' }
        }.to change(Gift, :count).by(1)
      end

      it 'redirects to user gifts page' do
        post :create, user_id: user, gift: { name: 'New Gift' }
        should redirect_to(user_gifts_path(user, render_new: true))
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

  describe 'PATCH #mark_as_purchased' do
    let!(:new_gift) { FactoryGirl.create(:gift, user: user) }

    describe 'user not logged in' do
      it 'does not update gift' do
        patch :mark_as_purchased, gift_id: new_gift
        expect(new_gift.reload.purchased).to be(nil)
        expect(new_gift.reload.purchaser_id).to be(nil)
      end

      it 'does not update gift count' do
        expect {
          patch :mark_as_purchased, gift_id: new_gift
        }.not_to change(Gift, :count)
      end

      it 'redirects to login page' do
        patch :mark_as_purchased, gift_id: new_gift
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'different user logged in' do
      before { direct_login(other_user) }

      describe 'when already purchased' do
        let!(:purchased_gift) do
          FactoryGirl.create(:purchased_gift, user: user,
                             purchaser_id: third_user.id)
        end

        it 'does not update gift' do
          patch :mark_as_purchased, gift_id: purchased_gift
          expect(purchased_gift.reload.purchased).to be(true)
          expect(purchased_gift.reload.purchaser_id).to eq(third_user.id)
        end

        it 'does not update gift count' do
          expect {
            patch :mark_as_purchased, gift_id: purchased_gift
          }.not_to change(Gift, :count)
        end

        it 'redirects to user gifts page' do
          patch :mark_as_purchased, gift_id: purchased_gift
          expect(response).to redirect_to(user_gifts_path(user))
        end
      end

      describe 'when not yet purchased' do
        it 'updates gift' do
          patch :mark_as_purchased, gift_id: new_gift
          expect(new_gift.reload.purchased).to be(true)
          expect(new_gift.reload.purchaser_id).to eq(other_user.id)
        end

        it 'does not update gift count' do
          expect {
            patch :mark_as_purchased, gift_id: new_gift
          }.not_to change(Gift, :count)
        end

        it 'redirects to user gifts page' do
          patch :mark_as_purchased, gift_id: new_gift
          expect(response).to redirect_to(user_gifts_path(user))
        end
      end
    end

    describe 'user of gift logged in' do
      before { direct_login(user) }

      it 'does not update gift' do
        patch :mark_as_purchased, gift_id: new_gift
        expect(new_gift.reload.purchased).to be(nil)
        expect(new_gift.reload.purchaser_id).to be(nil)
      end

      it 'does not update gift count' do
        expect {
          patch :mark_as_purchased, gift_id: new_gift
        }.not_to change(Gift, :count)
      end

      it 'redirects to user gifts page' do
        patch :mark_as_purchased, gift_id: new_gift
        expect(response).to redirect_to(user_gifts_path(user))
      end
    end
  end

  describe 'PATCH #mark_as_unpurchased' do
    let!(:new_gift) do
      FactoryGirl.create(:purchased_gift, user: user,
                         purchaser_id: other_user.id)
    end

    describe 'user not logged in' do
      it 'does not update gift' do
        patch :mark_as_unpurchased, gift_id: new_gift
        expect(new_gift.reload.purchased).to be(true)
        expect(new_gift.reload.purchaser_id).to eq(other_user.id)
      end

      it 'does not update gift count' do
        expect {
          patch :mark_as_unpurchased, gift_id: new_gift
        }.not_to change(Gift, :count)
      end

      it 'redirects to login page' do
        patch :mark_as_unpurchased, gift_id: new_gift
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'correct user logged in' do
      before { direct_login(other_user) }

      it 'updates gift' do
        patch :mark_as_unpurchased, gift_id: new_gift
        expect(new_gift.reload.purchased).to be(false)
        expect(new_gift.reload.purchaser_id).to be(nil)
      end

      it 'does not update gift count' do
        expect {
          patch :mark_as_unpurchased, gift_id: new_gift
        }.not_to change(Gift, :count)
      end

      it 'redirects to user gifts page' do
        patch :mark_as_unpurchased, gift_id: new_gift
        expect(response).to redirect_to(user_gifts_path(user))
      end
    end

    describe 'user of gift logged in' do
      before { direct_login(user) }

      it 'does not update gift' do
        patch :mark_as_unpurchased, gift_id: new_gift
        expect(new_gift.reload.purchased).to be(true)
        expect(new_gift.reload.purchaser_id).to eq(other_user.id)
      end

      it 'does not update gift count' do
        expect {
          patch :mark_as_unpurchased, gift_id: new_gift
        }.not_to change(Gift, :count)
      end

      it 'redirects to user gifts page' do
        patch :mark_as_unpurchased, gift_id: new_gift
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