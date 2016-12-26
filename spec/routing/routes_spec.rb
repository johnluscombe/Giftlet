require_relative '../rails_helper'

describe 'Routes' do
  describe 'UsersController' do
    it 'routes GET #index' do
      expect(:get => 'users').to route_to(
                                     controller: 'users',
                                     action: 'index'
                                 )
    end

    it 'routes GET #new' do
      expect(:get => 'users/new').to route_to(
                                         controller: 'users',
                                         action: 'new'
                                     )
    end

    it 'routes POST #create' do
      expect(:post => 'users').to route_to(
                                      controller: 'users',
                                      action: 'create'
                                  )
    end

    it 'routes GET #edit_basic_information' do
      expect(:get => 'edit_basic_information').to route_to(
                                                      controller: 'users',
                                                      action: 'edit_basic_information'
                                                  )
    end

    it 'routes GET #edit_password' do
      expect(:get => 'edit_password').to route_to(
                                             controller: 'users',
                                             action: 'edit_password'
                                         )
    end

    it 'routes PATCH #update_basic_information' do
      expect(:patch => 'update_basic_information').to route_to(
                                                          controller: 'users',
                                                          action: 'update_basic_information'
                                                      )
    end

    it 'routes PATCH #update_password' do
      expect(:patch => 'update_password').to route_to(
                                                 controller: 'users',
                                                 action: 'update_password'
                                             )
    end
  end

  describe 'GiftsController' do
    it 'routes GET #index' do
      expect(:get => 'users/1/gifts').to route_to(
                                             controller: 'gifts',
                                             action: 'index',
                                             user_id: '1'
                                         )
    end

    it 'routes POST #create' do
      expect(:post => 'gifts').to route_to(
                                      controller: 'gifts',
                                      action: 'create'
                                  )
    end

    it 'routes PATCH #update' do
      expect(:patch => 'gifts/1').to route_to(
                                         controller: 'gifts',
                                         action: 'update',
                                         id: '1'
                                     )
    end

    it 'routes PATCH #mark_as_purchased' do
      expect(:patch => 'gifts/1/mark_as_purchased').to route_to(
                                                           controller: 'gifts',
                                                           action: 'mark_as_purchased',
                                                           gift_id: '1'
                                                       )
    end

    it 'routes PATCH #mark_as_unpurchased' do
      expect(:patch => 'gifts/1/mark_as_unpurchased').to route_to(
                                                           controller: 'gifts',
                                                           action: 'mark_as_unpurchased',
                                                           gift_id: '1'
                                                       )
    end

    it 'routes DELETE #destroy' do
      expect(:delete => 'gifts/1').to route_to(
                                          controller: 'gifts',
                                          action: 'destroy',
                                          id: '1'
                                      )
    end
  end
end