# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for admin Users' do
  describe '#GET /api/v1/admin/users' do
    it 'routes /api/v1/admin/users to the admin users controller' do
      expect(get: '/api/v1/admin/users').to route_to(
        controller: 'api/v1/admin/users', action: 'index'
      )
    end

    it 'routes to /api/v1/admin/users#index' do
      expect(get: '/api/v1/admin/users').to be_routable
    end
  end

  describe '#DELETE /api/v1/admin/users/:id' do
    it 'routes /api/v1/admin/users to the admin users controller' do
      expect(delete: '/api/v1/admin/users/:id').to route_to(
        controller: 'api/v1/admin/users', action: 'destroy', id: ':id'
      )
    end

    it 'routes to /api/v1/admin/users#delete' do
      expect(delete: '/api/v1/admin/users/:id').to be_routable
    end
  end
end
