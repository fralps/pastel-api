# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for DashboardStats' do
  describe '/api/v1/stats/dashboard_stats' do
    it 'routes /api/v1/stats/dashboard_stats to the dashboard_stats controller' do
      expect(get: '/api/v1/stats/dashboard_stats').to route_to(
        controller: 'api/v1/stats/dashboard_stats', action: 'index'
      )
    end

    it 'routes to /api/v1/stats/dashboard_stats#index' do
      expect(get: '/api/v1/stats/dashboard_stats').to be_routable
    end

    it 'does not route to /api/v1/stats/dashboard_stats#post' do
      expect(post: '/api/v1/stats/dashboard_stats').not_to be_routable
    end

    it 'does not route to /api/v1/stats/dashboard_stats#put' do
      expect(put: '/api/v1/stats/dashboard_stats').not_to be_routable
    end

    it 'does not route to /api/v1/stats/dashboard_stats#destroy' do
      expect(delete: '/api/v1/stats/dashboard_stats').not_to be_routable
    end
  end
end
