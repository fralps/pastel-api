# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:firstname) }
    it { is_expected.to validate_presence_of(:lastname) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('test').for(:email) }

    it 'is expected to define a ROLES array constant' do
      expect(described_class::ITEMS_PER_PAGE).to eq(15)
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:sleeps).dependent(:destroy) }
  end
end
