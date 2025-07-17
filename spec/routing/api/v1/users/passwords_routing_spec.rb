# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for Passwords' do
  describe '/api/v1/users/password' do
    it 'routes /api/v1/users/password to the passwords controller' do
      expect(post: '/api/v1/users/password').to route_to(
        format: :json, controller: 'api/v1/users/passwords', action: 'create'
      )
    end

    it 'routes /api/v1/users/password#update to the passwords controller' do
      expect(put: '/api/v1/users/password').to route_to(
        format: :json, controller: 'api/v1/users/passwords', action: 'update'
      )
    end

    it 'does not routes to /api/v1/users/passwords#destroy' do
      expect(delete: '/api/v1/users/passwords').not_to be_routable
    end
  end
end
