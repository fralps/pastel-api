# frozen_string_literal: true

RSpec.shared_examples_for 'A no content response' do |_params|
  it 'has a no content status code' do
    expect(response).to be_no_content
  end

  it 'returns no content http status code' do
    expect(response).to have_http_status(:no_content)
  end
end
