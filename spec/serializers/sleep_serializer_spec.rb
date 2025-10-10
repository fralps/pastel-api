# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepSerializer do
  let(:user) { create(:user) }
  let(:sleep) { create(:sleep, user:) }

  describe 'index_and_create view' do
    let(:serialized_sleep) { described_class.render_as_hash(sleep, view: :index_and_create) }

    it 'renders the expected keys' do
      expect(serialized_sleep.keys).to contain_exactly(:id, :title, :date, :description, :sleep_type, :tags_attributes,
                                                       :current_mood)
    end

    it 'renders the correct id' do
      expect(serialized_sleep[:id]).to eq(sleep.id)
    end

    it 'renders the correct title' do
      expect(serialized_sleep[:title]).to eq(sleep.title)
    end

    it 'renders the correct formatted date' do
      expect(serialized_sleep[:date]).to be_present
    end
  end

  describe 'update_and_show view' do
    let(:serialized_sleep) { described_class.render_as_hash(sleep, view: :update_and_show) }

    it 'renders the expected keys' do
      expect(serialized_sleep.keys).to contain_exactly(:id, :date, :description, :happened,
                                                       :intensity, :current_mood, :title,
                                                       :datepicker_date, :formatted_date,
                                                       :tags_attributes)
    end

    it 'renders the correct id' do
      expect(serialized_sleep[:id]).to eq(sleep.id)
    end

    it 'renders the correct date' do
      expect(serialized_sleep[:date]).to eq(sleep.date)
    end

    it 'renders the correct description' do
      expect(serialized_sleep[:description]).to eq(sleep.description)
    end

    it 'renders the correct happened' do
      expect(serialized_sleep[:happened]).to eq(sleep.happened)
    end

    it 'renders the correct intensity' do
      expect(serialized_sleep[:intensity]).to eq(sleep.intensity)
    end

    it 'renders the correct current_mood' do
      expect(serialized_sleep[:current_mood]).to eq(sleep.current_mood)
    end

    it 'renders the correct title' do
      expect(serialized_sleep[:title]).to eq(sleep.title)
    end

    it 'renders the correct datepicker_date' do
      expect(serialized_sleep[:datepicker_date]).to eq(sleep.date.strftime('%m/%d/%Y'))
    end

    it 'renders the correct formatted_date' do
      expect(serialized_sleep[:formatted_date]).to eq(sleep.date.strftime('%d/%m/%Y'))
    end

    it 'renders the correct tags_attributes' do
      expect(serialized_sleep[:tags_attributes]).to eq(TagSerializer.render_as_hash(sleep.tags))
    end
  end
end
