# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sleep do
  let(:user) { create(:user) }
  let(:sleep) { create(:sleep, user:) }

  describe 'constants' do
    it 'defines ITEMS_PER_PAGE as 10' do
      expect(described_class::ITEMS_PER_PAGE).to eq(10)
    end

    it 'defines all INTENSITY values' do
      expect(described_class::INTENSITY.values).to contain_exactly(
        'very_clear', 'clear', 'unclear', 'very_unclear'
      )
    end

    it 'defines all HAPPENED values' do
      expect(described_class::HAPPENED.values).to contain_exactly(
        'falling_asleep', 'sleeping', 'waking_up', 'napping'
      )
    end

    it 'defines all SLEEP_TYPE values' do
      expect(described_class::SLEEP_TYPE.values).to contain_exactly(
        'dream', 'nightmare', 'lucid', 'sleep_paralysis',
        'sleep_walking', 'sleep_talking', 'sleep_apnea', 'erotic'
      )
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tags).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:current_mood) }

    it { is_expected.to validate_inclusion_of(:intensity).in_array(described_class::INTENSITY.values) }
    it { is_expected.to validate_inclusion_of(:happened).in_array(described_class::HAPPENED.values) }
    it { is_expected.to validate_inclusion_of(:sleep_type).in_array(described_class::SLEEP_TYPE.values) }

    it 'is invalid with an unknown intensity' do
      sleep = build(:sleep, intensity: 'unknown')
      expect(sleep).not_to be_valid
    end

    it 'is invalid with an unknown happened' do
      sleep = build(:sleep, happened: 'unknown')
      expect(sleep).not_to be_valid
    end

    it 'is invalid with an unknown sleep_type' do
      sleep = build(:sleep, sleep_type: 'unknown')
      expect(sleep).not_to be_valid
    end
  end

  describe 'nested attributes' do
    it 'creates the tag when using nested attributes' do
      sleep = create(:sleep, user:, tags_attributes: [{ name: 'Flying' }])
      expect(sleep.tags.count).to eq(1)
    end

    it 'sets the tag name when using nested attributes' do
      sleep = create(:sleep, user:, tags_attributes: [{ name: 'Flying' }])
      expect(sleep.tags.first.name).to eq('Flying')
    end

    it 'destroys tags via nested attributes' do
      tag = create(:tag, sleep:)
      sleep.update!(tags_attributes: [{ id: tag.id, _destroy: true }])
      expect(sleep.tags).to be_empty
    end
  end

  describe 'encryption' do
    it 'encrypts title' do
      expect(described_class.encrypted_attributes).to include(:title)
    end

    it 'encrypts description' do
      expect(described_class.encrypted_attributes).to include(:description)
    end

    it 'encrypts current_mood' do
      expect(described_class.encrypted_attributes).to include(:current_mood)
    end

    it 'encrypts analysis' do
      expect(described_class.encrypted_attributes).to include(:analysis)
    end
  end

  describe 'scopes' do
    describe '.ordered_by_date' do
      it 'returns sleeps ordered by date descending' do
        old_sleep = create(:sleep, user:, date: 3.days.ago)
        mid_sleep = create(:sleep, user:, date: 2.days.ago)
        recent_sleep = create(:sleep, user:, date: 1.day.ago)

        expect(described_class.ordered_by_date.to_a).to eq([recent_sleep, mid_sleep, old_sleep])
      end
    end

    describe '.group_by_month_from_current_year' do
      it 'returns a Hash' do
        result = described_class.group_by_month_from_current_year
        expect(result).to be_a(Hash)
      end

      it 'counts only sleeps from the current year' do
        create(:sleep, user:, date: Time.zone.now)
        create(:sleep, user:, date: 1.month.ago)
        create(:sleep, user:, date: 1.year.ago)

        expect(described_class.group_by_month_from_current_year.values.sum).to eq(2)
      end

      it 'excludes sleeps from previous years' do
        create(:sleep, user:, date: 2.years.ago)

        result = described_class.group_by_month_from_current_year
        expect(result.values.sum).to eq(0)
      end
    end

    describe '.years' do
      it 'returns a Hash' do
        result = described_class.years(2.years.ago..Time.zone.now)
        expect(result).to be_a(Hash)
      end

      it 'counts sleeps grouped by year for the given range' do
        create(:sleep, user:, date: Time.zone.now)
        create(:sleep, user:, date: 1.year.ago)

        expect(described_class.years(2.years.ago..Time.zone.now).values.sum).to eq(2)
      end
    end

    describe '.ai_analyzed' do
      it 'includes sleeps with analysis and status done' do
        analyzed = create(:sleep, user:, analysis: 'Some analysis', analysis_status: 'done')

        expect(described_class.ai_analyzed).to include(analyzed)
      end

      it 'excludes sleeps with no analysis' do
        create(:sleep, user:, analysis: nil, analysis_status: 'done')

        expect(described_class.ai_analyzed).to be_empty
      end

      it 'excludes sleeps with analysis but status not done' do
        create(:sleep, user:, analysis: 'Some analysis', analysis_status: 'in_progress')

        expect(described_class.ai_analyzed).to be_empty
      end
    end
  end

  describe 'tags ordering' do
    it 'returns tags ordered by id ascending' do
      tag_b = create(:tag, name: 'B', sleep:)
      tag_a = create(:tag, name: 'A', sleep:)

      expect(sleep.tags.to_a).to eq([tag_b, tag_a])
    end
  end

  describe '#mark_as_analysis_not_started' do
    let(:sleep) { create(:sleep, user:, analysis_status: 'done') }

    it 'sets analysis_status to not_started' do
      sleep.mark_as_analysis_not_started
      expect(sleep.reload.analysis_status).to eq('not_started')
    end

    it 'persists the change' do
      sleep.mark_as_analysis_not_started
      expect(described_class.find(sleep.id).analysis_status).to eq('not_started')
    end
  end

  describe '#mark_as_analysis_done' do
    let(:analysis_text) { 'This dream involves flying over mountains.' }

    it 'sets analysis_status to done' do
      sleep.mark_as_analysis_done(analysis_text)
      expect(sleep.reload.analysis_status).to eq('done')
    end

    it 'sets the analysis attribute' do
      sleep.mark_as_analysis_done(analysis_text)
      expect(sleep.reload.analysis).to eq(analysis_text)
    end

    it 'persists the changes' do
      sleep.mark_as_analysis_done(analysis_text)
      updated = described_class.find(sleep.id)
      expect(updated.analysis_status).to eq('done')
    end
  end

  describe 'factory' do
    it 'creates a valid sleep' do
      expect(build(:sleep)).to be_valid
    end

    described_class::SLEEP_TYPE.each_key do |type|
      it "creates a valid sleep with trait :#{type}" do
        expect(build(:sleep, type)).to be_valid
      end
    end
  end
end
