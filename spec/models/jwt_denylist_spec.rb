# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtDenylist do
  describe 'Schema' do
    it 'has a valid schema' do
      expect(described_class.new).to be_valid
    end

    it { is_expected.to have_db_column(:id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:jti).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:exp).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe 'Revocation Strategies' do
    it 'includes Devise JWT Revocation Strategies Denylist' do
      expect(described_class).to include(Devise::JWT::RevocationStrategies::Denylist)
    end
  end

  describe 'Table Name' do
    it 'has the correct table name' do
      expect(described_class.table_name).to eq('jwt_denylist')
    end
  end
end
