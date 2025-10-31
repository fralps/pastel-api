# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Stats::DashboardStatsController, type: :request do
  context 'when user has records' do
    describe '#GET /api/v1/stats/dashboard_stats' do
      let(:user) { create(:user) }

      before do
        create_list(:sleep, 10, sleep_type: 'dream', user: user)
        create_list(:sleep, 5, sleep_type: 'lucid', user: user)
        create_list(:sleep, 2, sleep_type: 'nightmare', user: user)
        create_list(:sleep, 8, sleep_type: 'sleep_paralysis', user: user)
        create_list(:sleep, 4, sleep_type: 'sleep_walking', user: user)
        create_list(:sleep, 3, sleep_type: 'sleep_talking', user: user)
        create_list(:sleep, 6, sleep_type: 'sleep_apnea', user: user)
        create_list(:sleep, 1, sleep_type: 'erotic', user: user)
        get '/api/v1/stats/dashboard_stats', headers: auth_headers(user)
      end

      it_behaves_like 'A success response'

      it 'returns the current_user totals json key' do
        expect(json_response).to include('totals')
      end

      # it 'returns the current_user by_month json key' do
      #   expect(json_response).to include('by_month')
      # end

      # it 'returns the current_user by_year json key' do
      #   expect(json_response).to include('by_year')
      # end

      # TOTALS
      it 'returns correct dreams total count' do
        expect(json_response['totals']['dream']).to eq(10)
      end

      it 'returns correct lucids total count' do
        expect(json_response['totals']['lucid']).to eq(5)
      end

      it 'returns correct nightmares total count' do
        expect(json_response['totals']['nightmare']).to eq(2)
      end

      it 'returns correct sleep_paralysis total count' do
        expect(json_response['totals']['sleep_paralysis']).to eq(8)
      end

      it 'returns correct sleep_walking total count' do
        expect(json_response['totals']['sleep_walking']).to eq(4)
      end

      it 'returns correct sleep_talking total count' do
        expect(json_response['totals']['sleep_talking']).to eq(3)
      end

      it 'returns correct sleep_apnea total count' do
        expect(json_response['totals']['sleep_apnea']).to eq(6)
      end

      it 'returns correct erotic total count' do
        expect(json_response['totals']['erotic']).to eq(1)
      end
    end

    #     # BY_MONTH
    #     it 'returns dreams count by month' do
    #       expect(json_response['by_month']['dreams']).not_to be_nil
    #     end

    #     it 'returns lucids count by month' do
    #       expect(json_response['by_month']['lucids']).not_to be_nil
    #     end

    #     it 'returns nightmares count by month' do
    #       expect(json_response['by_month']['nightmares']).not_to be_nil
    #     end

    #     # BY_YEAR
    #     it 'returns dreams count by year' do
    #       expect(json_response['by_year']['dreams']).not_to be_nil
    #     end

    #     it 'returns lucids count by year' do
    #       expect(json_response['by_year']['lucids']).not_to be_nil
    #     end

    #     it 'returns nightmares count by year' do
    #       expect(json_response['by_year']['nightmares']).not_to be_nil
    #     end
    #   end
  end

  context 'when user does not have records' do
    describe '#GET /api/v1/stats/dashboard_stats' do
      let(:user) { create(:user) }

      before do
        get '/api/v1/stats/dashboard_stats', headers: auth_headers(user)
      end

      it_behaves_like 'A success response'
    end
  end
end
