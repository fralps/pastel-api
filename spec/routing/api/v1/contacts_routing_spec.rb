# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for Contacts' do
  describe '/api/v1/contacts' do
    it 'routes /api/v1/contacts to the contacts controller' do
      expect(post: '/api/v1/contacts').to route_to(
        controller: 'api/v1/contacts', action: 'create'
      )
    end

    it 'routes to /api/v1/contacts#index' do
      expect(get: '/api/v1/contacts').not_to be_routable
    end

    it 'does not route to /api/v1/contacts/:id#get' do
      expect(get: '/api/v1/contacts/:id').not_to be_routable
    end

    it 'does not route to /api/v1/contacts#put' do
      expect(put: '/api/v1/contacts').not_to be_routable
    end

    it 'does not route to /api/v1/contacts#destroy' do
      expect(delete: '/api/v1/contacts').not_to be_routable
    end
  end
end
