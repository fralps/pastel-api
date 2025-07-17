# frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe Api::V1::Stats::DashboardStatsController, type: :request do
#   context 'when user has records' do
#     describe '#GET /api/v1/stats/dashboard_stats' do
#       let(:user) { create(:user) }
#       let(:sleeps_count) { 10 }

#       before do
#         create_list(:sleep, sleeps_count, user:)
#         get '/api/v1/stats/dashboard_stats', headers: auth_headers(user)
#       end

#       it_behaves_like 'A success response'

#       it 'returns the current_user totals json key' do
#         expect(json_response).to include('totals')
#       end

#       it 'returns the current_user by_month json key' do
#         expect(json_response).to include('by_month')
#       end

#       it 'returns the current_user by_year json key' do
#         expect(json_response).to include('by_year')
#       end

#       # TOTALS
#       it 'returns correct dreams total count' do
#         expect(json_response['totals']['dreams']).to eq(dreams_count)
#       end

#       it 'returns correct lucids total count' do
#         expect(json_response['totals']['lucids']).to eq(lucids_count)
#       end

#       it 'returns correct nightmares total count' do
#         expect(json_response['totals']['nightmares']).to eq(nightmares_count)
#       end

#       # BY_MONTH
#       it 'returns dreams count by month' do
#         expect(json_response['by_month']['dreams']).not_to be_nil
#       end

#       it 'returns lucids count by month' do
#         expect(json_response['by_month']['lucids']).not_to be_nil
#       end

#       it 'returns nightmares count by month' do
#         expect(json_response['by_month']['nightmares']).not_to be_nil
#       end

#       # BY_YEAR
#       it 'returns dreams count by year' do
#         expect(json_response['by_year']['dreams']).not_to be_nil
#       end

#       it 'returns lucids count by year' do
#         expect(json_response['by_year']['lucids']).not_to be_nil
#       end

#       it 'returns nightmares count by year' do
#         expect(json_response['by_year']['nightmares']).not_to be_nil
#       end
#     end
#   end

#   context 'when user does not have records' do
#     describe '#GET /api/v1/stats/dashboard_stats' do
#       let(:user) { create(:user) }

#       before do
#         get '/api/v1/stats/dashboard_stats', headers: auth_headers(user)
#       end

#       it_behaves_like 'A success response'
#     end
#   end
# end
