# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::SessionsController, type: :request do
  let(:user) { create(:user) }

  describe '#POST /api/v1/users/sign_in' do
    subject(:request) do
      post '/api/v1/users/sign_in', params: {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    context 'when user successfully logs in' do
      before { request }

      it_behaves_like 'A created response'

      it 'returns the user' do
        expect(json_response).to include_json(firstname: user.firstname)
      end

      it 'has a current_user' do
        expect(controller.current_user).not_to be_nil
      end
    end

    context 'when user fails to log in' do
      before do
        user.password = 'wrong_password'
        request
      end

      it 'returns 401' do
        expect(response).to be_unauthorized
      end
    end
  end

  describe '#DELETE /api/v1/users/sign_out' do
    let(:user) { create(:user) }

    before do
      delete '/api/v1/users/sign_out', headers: auth_headers(user)
    end

    it 'returns 401' do
      expect(response).to be_unauthorized
    end
  end
end
