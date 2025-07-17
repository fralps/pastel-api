# frozen_string_literal: true

RSpec.shared_examples_for 'A created response' do |_params|
  it 'has a successful status code' do
    expect(response).to be_successful
  end

  it 'returns content in json' do
    expect(response.content_type).to include('application/json')
  end

  it 'has a created status code' do
    expect(response).to be_created
  end
end
