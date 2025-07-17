# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for Confirmations' do
  describe '/api/v1/users/confirmation' do
    it 'routes /api/v1/users/confirmation to the confirmations controller' do
      expect(get: '/api/v1/users/confirmation').to route_to(
        format: :json, controller: 'api/v1/users/confirmations', action: 'show'
      )
    end

    it 'routes to /api/v1/users/confirmations#get' do
      expect(get: '/api/v1/users/confirmation').to be_routable
    end

    it 'does not routes to /api/v1/users/confirmations#destroy' do
      expect(delete: '/api/v1/users/confirmations').not_to be_routable
    end
  end
end
