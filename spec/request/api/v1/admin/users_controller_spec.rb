# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::UsersController, type: :request do
  describe '#GET /api/v1/admin/users' do
    let(:admin_user) { create(:user, :admin_user) }

    before do
      create_list(:user, 10, :other_user)
      create_list(:user, 10, :other_user)
      create_list(:user, 10, :other_user)
      get '/api/v1/admin/users', headers: auth_headers(admin_user), params: { page: 1 }
    end

    it_behaves_like 'A success response'

    it 'returns last 10 users' do
      expect(JSON.parse(json_response['paginated_result']).size).to eq(User::ITEMS_PER_PAGE)
    end

    it 'returns second page of users' do
      get '/api/v1/admin/users', headers: auth_headers(admin_user), params: { page: 2 }
      expect(JSON.parse(json_response['paginated_result']).size).to eq(User::ITEMS_PER_PAGE)
    end

    it 'returns first page even with wrong params' do
      get '/api/v1/admin/users', headers: auth_headers(admin_user), params: { page: 0 }
      expect(JSON.parse(json_response['paginated_result']).size).to eq(User::ITEMS_PER_PAGE)
    end

    it 'returns users count' do
      get '/api/v1/admin/users', headers: auth_headers(admin_user), params: { page: 1 }
      expect(JSON.parse(json_response['count'])).to eq(User.all.size)
    end

    context 'when user doing the request is not an admin' do
      let(:not_admin_user) { create(:user) }

      before do
        create_list(:user, 15, :other_user)
        get '/api/v1/admin/users', headers: auth_headers(not_admin_user), params: { page: 1 }
      end

      it 'has a 401 status code' do
        expect(response).to be_unauthorized
      end
    end
  end

  describe '#DELETE /api/v1/admin/users/:id' do
    subject(:request) { delete "/api/v1/admin/users/#{user.id}", headers: auth_headers(admin_user) }

    let(:admin_user) { create(:user, :admin_user) }
    let(:user) { create(:user) }

    context 'when admin deletes an user' do
      it 'has a successful status code' do
        request
        expect(response).to be_successful
      end
    end

    context 'when user doing the request is not an admin' do
      let(:not_admin_user) { create(:user, email: 'not-admin@user.com') }

      before do
        delete "/api/v1/admin/users/#{user.id}", headers: auth_headers(not_admin_user)
      end

      it 'has a 401 status code' do
        expect(response).to be_unauthorized
      end
    end
  end
end
