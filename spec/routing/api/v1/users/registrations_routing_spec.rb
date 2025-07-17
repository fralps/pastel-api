# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for Registrations' do
  describe '/api/v1/users/sign_up' do
    it 'routes /api/v1/users/sign_up to the registrations controller' do
      expect(post: '/api/v1/users/sign_up').to route_to(
        format: :json, controller: 'api/v1/users/registrations', action: 'create'
      )
    end

    it 'routes to /api/v1/users#destroy' do
      expect(delete: '/api/v1/users').to be_routable
    end
  end
end
