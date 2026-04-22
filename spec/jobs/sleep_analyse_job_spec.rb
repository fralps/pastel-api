# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepAnalyseJob do
  describe '.perform_later' do
    let(:user) { create(:user) }
    let(:sleep) { create(:sleep, user:) }
    let(:locale) { :fr }

    it 'enqueues job on default queue' do
      expect {
        described_class.perform_later(sleep.id, locale)
      }.to have_enqueued_job(described_class).on_queue('default')
    end

    it 'returns early if sleep is not found' do
      allow(SleepAnalysisService).to receive(:call)

      perform_enqueued_jobs do
        described_class.perform_later('wrong_sleep_id', locale)
      end

      expect(SleepAnalysisService).not_to have_received(:call)
    end

    it 'calls SleepAnalysisService with the correct sleep' do
      allow(SleepAnalysisService).to receive(:call)

      perform_enqueued_jobs do
        described_class.perform_later(sleep.id, locale)
      end

      expect(SleepAnalysisService).to have_received(:call).with(sleep, locale)
    end
  end
end
