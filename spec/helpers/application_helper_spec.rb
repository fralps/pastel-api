# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#front_url' do
    before do
      allow(ENV).to receive(:fetch).with('WEB_BASE_URL').and_return('https://www.example.com')
    end

    context 'when path is empty' do
      it 'returns the base URL' do
        expect(helper.front_url).to eq('https://www.example.com/')
      end
    end

    context 'when path is provided' do
      it 'returns the full URL with path' do
        expect(helper.front_url('about')).to eq('https://www.example.com/about')
      end
    end
  end
end
