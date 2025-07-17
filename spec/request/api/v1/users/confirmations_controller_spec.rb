# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::ConfirmationsController, type: :request do
  let(:user) { create(:user, confirmed_at: nil) }

  describe '#GET /api/v1/users/confirmation' do
    context 'when user confirms his account successfully' do
      before do
        get '/api/v1/users/confirmation', params: {
          confirmation_token: user.confirmation_token
        }
      end

      it_behaves_like 'A success response'
    end

    context 'when user fails to confirm his account' do
      before do
        get '/api/v1/users/confirmation', params: {
          confirmation_token: 'confirmation_token'
        }
      end

      it 'returns 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
