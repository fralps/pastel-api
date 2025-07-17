# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::RegistrationsController, type: :request do
  describe '#POST /api/v1/users/sign_up' do
    subject(:request) {
      post '/api/v1/users/sign_up', params: {
        user: params
      }
    }

    let(:params) {
      {
        email: 'new_user@kinoba.fr',
        password: 'password',
        password_confirmation: 'password',
        firstname: 'Firstname',
        lastname: 'Lastname'
      }
    }

    before do
      request
    end

    it 'returns 200' do
      expect(response).to be_successful
    end

    it 'returns the user' do
      expect(json_response).to include_json(firstname: 'Firstname')
    end

    it 'sends an email to user' do
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end
  end

  describe '#PUT /api/v1/users/profile' do
    subject(:request) {
      put '/api/v1/users/profile', params: {
        user: {
          firstname: 'New firstname',
          lastname: 'New lastname',
          current_password: user.password
        }
      }, headers: auth_headers(user)
    }

    let(:user) { create(:user) }

    context 'when user successfully change his profile' do
      before do
        request
      end

      it_behaves_like 'A success response'

      it 'changes the firstname' do
        controller.current_user.reload
        expect(controller.current_user.firstname).to eq 'New firstname'
      end

      it 'changes the lastname' do
        controller.current_user.reload
        expect(controller.current_user.lastname).to eq 'New lastname'
      end
    end

    context 'with password updated' do
      let(:params) do
        {
          password: 'new_password',
          password_confirmation: 'new_password',
          current_password: user.password
        }
      end

      before do
        request
      end

      it_behaves_like 'A success response'
    end
  end

  describe '#DELETE /api/v1/users' do
    subject(:request) {
      delete '/api/v1/users', headers: auth_headers(user)
    }

    let(:user) { create(:user) }

    context 'when user successfully delete his profile' do
      before do
        request
      end

      it_behaves_like 'A no content response'

      it 'deletes the user' do
        expect(controller.current_user).to be_nil
      end
    end
  end
end
