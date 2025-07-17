# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PingsController, type: :request do
  describe '#GET /api/v1/pings' do
    before do
      get '/api/v1/pings'
    end

    it_behaves_like 'A success response'

    it 'returns the dyno status' do
      expect(json_response).to include('dyno_status')
    end

    it 'returns a JSON payload with the correct message' do
      expect(json_response['dyno_status']).to eq('Dyno is up and running')
    end
  end
end
