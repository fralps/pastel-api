# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for Sessions' do
  describe '/api/v1/users/sign_in' do
    it 'routes /api/v1/users/sign_in to the sessions controller' do
      expect(post: '/api/v1/users/sign_in').to route_to(
        format: :json, controller: 'api/v1/users/sessions', action: 'create'
      )
    end

    it 'routes to /api/v1/users/sign_out#destroy' do
      expect(delete: '/api/v1/users/sign_out').to be_routable
    end
  end
end
