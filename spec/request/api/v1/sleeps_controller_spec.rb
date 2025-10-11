# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SleepsController, type: :request do
  describe '#GET /api/v1/sleeps' do
    let(:user) { create(:user) }

    before do
      create_list(:sleep, 15, user:)
      get '/api/v1/sleeps', headers: auth_headers(user), params: { page: 1 }
    end

    it_behaves_like 'A success response'

    it 'returns last 10 sleeps' do
      expect(json_response['paginated_result'].size).to eq(Sleep::ITEMS_PER_PAGE)
    end

    it 'returns second page of sleeps' do
      get '/api/v1/sleeps', headers: auth_headers(user), params: { page: 2 }
      expect(json_response['paginated_result'].size).to eq(Sleep::ITEMS_PER_PAGE - 5)
    end

    it 'returns first page even with wrong params' do
      get '/api/v1/sleeps', headers: auth_headers(user), params: { page: 0 }
      expect(json_response['paginated_result'].size).to eq(Sleep::ITEMS_PER_PAGE)
    end

    context 'when request has a query params' do
      let(:sleeps_count) { 5 }

      before do
        create_list(:sleep, sleeps_count, user:, title: 'QUERY test')
        get '/api/v1/sleeps', headers: auth_headers(user), params: { page: 1, query: 'query' }
      end

      it_behaves_like 'A success response'

      it 'returns 10 matching record' do
        expect(json_response['paginated_result'].size).to eq(sleeps_count)
      end
    end
  end

  describe '#GET /api/v1/sleeps/:id' do
    let(:user) { create(:user) }
    let(:sleep) { create(:sleep, user:) }
    let(:wrong_id) { 40 }

    context 'with a correct id' do
      before do
        get "/api/v1/sleeps/#{sleep.id}", headers: auth_headers(user)
      end

      it_behaves_like 'A success response'

      it 'returns the sleep' do
        expect(json_response).to eq(JSON[SleepSerializer.render(sleep, view: :update_and_show)])
      end
    end

    context 'with an incorrect id' do
      before do
        get "/api/v1/sleeps/#{wrong_id}", headers: auth_headers(user)
      end

      it 'has a 404 status code' do
        expect(response).to be_not_found
      end
    end
  end

  describe '#POST /api/v1/sleeps' do
    let(:user) { create(:user) }
    let(:params) do
      {
        title: 'Great dream',
        date: {
          calendar: {
            identifier: 'gregory'
          },
          era: 'AD',
          year: 2025,
          month: 9,
          day: 30
        },
        description: 'Great description of my last night dream',
        current_mood: 'Good mood',
        intensity: Sleep::INTENSITY[Sleep::INTENSITY.keys.sample],
        happened: Sleep::HAPPENED[Sleep::HAPPENED.keys.sample],
        tags_attributes: [
          { name: 'first tag' },
          { name: 'second tag' },
          { name: 'third tag' },
          { name: 'fourth tag' }
        ],
        user:
      }
    end

    before do
      post '/api/v1/sleeps', headers: auth_headers(user), params: {
        sleep: params
      }
    end

    it_behaves_like 'A created response'

    it 'returns the right sleep title' do
      expect(json_response['title']).to eq('Great dream')
    end

    it 'increments Tags table by 4' do
      expect(Tag.all.size).to eq(4)
    end

    it 'returns 4 tags for the sleep' do
      expect(Sleep.last.tags.size).to eq(4)
    end

    it 'saves a tag for the sleep' do
      expect(Sleep.last.tags.last.name).to eq('fourth tag')
    end
  end

  describe '#PATCH /api/v1/sleeps/:id' do
    subject(:request) { patch "/api/v1/sleeps/#{sleep.id}", headers: auth_headers(user), params: { sleep: params } }

    let(:user) { create(:user) }
    let(:sleep) { create(:sleep, user:) }
    let(:params) do
      {
        tags_attributes: [
          { name: 'first tag' },
          { name: 'second tag' },
          { name: 'third tag' },
          { name: 'fourth tag' }
        ]
      }
    end

    context 'when user has a sleep' do
      before { request }

      it_behaves_like 'A success response'

      it 'increments Tags table by 4' do
        expect(Tag.all.size).to eq(4)
      end

      it 'returns 4 tags for the sleep' do
        expect(sleep.tags.size).to eq(4)
      end

      it 'saves a tag for the sleep' do
        expect(sleep.tags.last.name).to eq('fourth tag')
      end
    end
  end

  describe '#DELETE /api/v1/sleeps/:id' do
    subject(:request) { delete "/api/v1/sleeps/#{sleep.id}", headers: auth_headers(user) }

    let(:user) { create(:user) }
    let(:sleep) { create(:sleep, user:) }

    context 'when user deletes his sleep' do
      it 'has a successful status code' do
        request
        expect(response).to be_successful
      end
    end

    context 'when user deletes a wrong sleep' do
      it 'has an not found error' do
        sleep.user = create(:user, :other_user)
        sleep.save!
        request
        expect(response).to be_not_found
      end
    end
  end
end
