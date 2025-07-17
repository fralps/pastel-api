# frozen_string_literal: true

RSpec.shared_examples_for 'A success response' do |_params|
  it 'has a successful status code' do
    expect(response).to be_successful
  end

  it 'returns content in json' do
    expect(response.content_type).to include('application/json')
  end

  it 'returns ok http status code' do
    expect(response).to have_http_status(:ok)
  end
end
