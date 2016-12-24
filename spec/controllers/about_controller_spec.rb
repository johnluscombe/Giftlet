require_relative '../rails_helper'
require_relative '../support/login'

describe AboutController do
  let(:user) { FactoryGirl.create(:user) }

  subject { response }

  describe 'GET #index' do
    describe 'user not logged in' do
      it 'renders :index template' do
        direct_login(user)
        get :index
        should render_template(:index)
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
end