# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepAnalysisService do
  let(:user) { create(:user) }
  let(:sleep_record) do
    create(:sleep,
           user:,
           title: 'Flying over mountains',
           description: 'I was flying over snowy mountains',
           current_mood: 'excited',
           intensity: 'clear',
           happened: 'sleeping',
           sleep_type: Sleep::SLEEP_TYPE[:dream])
  end

  let(:locale) { :fr }
  let(:service) { described_class.new(sleep_record, locale) }

  describe '#initialize' do
    it 'assigns the sleep record' do
      expect(service.sleep).to eq(sleep_record)
    end

    it 'reads the Mistral API key from the environment' do
      expect(service.mistral_api_key).to eq(ENV.fetch('MISTRAL_API_KEY', nil))
    end

    it 'sets the correct Mistral API URL' do
      expect(service.mistral_api_url).to eq('https://api.mistral.ai/v1/chat/completions')
    end

    it 'assigns the locale' do
      expect(service.locale).to eq(:fr)
    end
  end

  describe '#call', :vcr do
    context 'when the Mistral API returns a successful response',
            vcr: { cassette_name: 'sleep_analysis_service/success' } do
      before {
        create(:tag, name: 'flying', sleep: sleep_record)
        create(:tag, name: 'mountains', sleep: sleep_record)
      }

      it 'updates the sleep analysis field' do
        service.call
        expect(sleep_record.reload.analysis).to be_present
      end

      it 'sets analysis_status to done' do
        service.call
        expect(sleep_record.reload.analysis_status).to eq('done')
      end

      it 'persists the analysis text returned by the API' do
        service.call
        expect(sleep_record.reload.analysis).to include('flying')
      end
    end

    context 'when the Mistral API returns an error' do
      before do
        stub_request(:post, 'https://api.mistral.ai/v1/chat/completions')
          .to_return(status: 500, body: '', headers: {})
      end

      it 'does not update the analysis field' do
        service.call
        expect(sleep_record.reload.analysis).to be_nil
      end

      it 'does not set analysis_status to done' do
        service.call
        expect(sleep_record.reload.analysis_status).not_to eq('done')
      end

      it 'logs the error' do
        allow(Rails.logger).to receive(:error)
        service.call
        expect(Rails.logger).to have_received(:error).with(/Failed to get response from Mistral API/)
      end
    end

    context 'when a network error occurs' do
      before do
        stub_request(:post, 'https://api.mistral.ai/v1/chat/completions')
          .to_raise(StandardError.new('connection refused'))
      end

      it 'does not update the analysis field' do
        service.call
        expect(sleep_record.reload.analysis).to be_nil
      end

      it 'logs the error' do
        allow(Rails.logger).to receive(:error)
        service.call
        expect(Rails.logger).to have_received(:error).with(/Error while sending request to Mistral API/)
      end
    end
  end
end
