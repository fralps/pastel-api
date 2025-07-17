# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for Sleep' do
  describe '#GET /api/v1/sleeps' do
    it 'routes /api/v1/sleeps to the sleeps controller' do
      expect(get: '/api/v1/sleeps').to route_to(
        controller: 'api/v1/sleeps', action: 'index'
      )
    end

    it 'routes to /api/v1/sleeps#index' do
      expect(get: '/api/v1/sleeps').to be_routable
    end
  end

  describe '#GET /api/v1/sleeps/:id' do
    it 'routes /api/v1/sleeps to the sleeps controller' do
      expect(get: '/api/v1/sleeps/:id').to route_to(
        controller: 'api/v1/sleeps', action: 'show', id: ':id'
      )
    end

    it 'routes to /api/v1/sleeps#show' do
      expect(get: '/api/v1/sleeps/:id').to be_routable
    end
  end

  describe '#POST /api/v1/sleeps' do
    it 'routes /api/v1/sleeps to the sleeps controller' do
      expect(post: '/api/v1/sleeps').to route_to(
        controller: 'api/v1/sleeps', action: 'create'
      )
    end

    it 'routes to /api/v1/sleeps#post' do
      expect(post: '/api/v1/sleeps').to be_routable
    end
  end

  describe '#PUT /api/v1/sleeps/:id' do
    it 'routes /api/v1/sleeps to the sleeps controller' do
      expect(put: '/api/v1/sleeps/:id').to route_to(
        controller: 'api/v1/sleeps', action: 'update', id: ':id'
      )
    end

    it 'routes to /api/v1/sleeps#put' do
      expect(put: '/api/v1/sleeps/:id').to be_routable
    end
  end

  describe '#DELETE /api/v1/sleeps/:id' do
    it 'routes /api/v1/sleeps to the sleeps controller' do
      expect(delete: '/api/v1/sleeps/:id').to route_to(
        controller: 'api/v1/sleeps', action: 'destroy', id: ':id'
      )
    end

    it 'routes to /api/v1/sleeps#delete' do
      expect(delete: '/api/v1/sleeps/:id').to be_routable
    end
  end
end
