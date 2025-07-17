# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::PasswordsController, type: :request do
  let(:user) { create(:user) }

  describe '#POST /api/v1/users/password' do
    context 'when user asks for new password' do
      before do
        post '/api/v1/users/password', params: {
          user: {
            email: user.email
          }
        }
      end

      it_behaves_like 'A created response'

      it 'sends an email to user' do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end
    end

    context 'when user fails to ask for new password' do
      before do
        post '/api/v1/users/sign_in', params: {
          user: {
            email: 'wrong@email.com'
          }
        }
      end

      it 'sends 0 email to user' do
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end
  end

  describe '#PUT /api/v1/users/password' do
    let(:user_password) { create(:user) }

    context 'when user successfully changes his password' do
      before do
        token = user_password.send_reset_password_instructions
        put '/api/v1/users/password', headers: auth_headers(user_password), params: {
          user: {
            reset_password_token: token,
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it 'has a successful status code' do
        expect(response).to be_successful
      end

      it 'returns has a current_user' do
        expect(controller.current_user).to eq user_password
      end
    end

    context 'when user fails to change his password' do
      before do
        user_password.send_reset_password_instructions
        put '/api/v1/users/password', params: {
          user: {
            reset_password_token: 'token',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it 'returns 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'has a current_user to nil' do
        expect(controller.current_user).to be_nil
      end

      it 'has an error invalid token' do
        expect(json_response).to include_json(errors: { reset_password_token: ['n\'est pas valide'] })
      end
    end
  end
end
