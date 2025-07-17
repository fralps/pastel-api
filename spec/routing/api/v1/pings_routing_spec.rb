# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for Pings' do
  describe '/api/v1/pings' do
    it 'routes /api/v1/pings to the pings controller' do
      expect(get: '/api/v1/pings').to route_to(
        controller: 'api/v1/pings', action: 'index'
      )
    end

    it 'routes to /api/v1/pings#index' do
      expect(get: '/api/v1/pings').to be_routable
    end

    it 'does not route to /api/v1/pings#post' do
      expect(post: '/api/v1/pings').not_to be_routable
    end

    it 'does not route to /api/v1/pings#put' do
      expect(put: '/api/v1/pings').not_to be_routable
    end

    it 'does not route to /api/v1/pings#destroy' do
      expect(delete: '/api/v1/pings').not_to be_routable
    end
  end
end
