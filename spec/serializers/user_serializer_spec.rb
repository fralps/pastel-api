# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer do
  let(:user) { create(:user) }
  let(:serialized_user) { described_class.render_as_hash(user) }

  describe '#render' do
    it 'renders the user confirmed_at' do
      expect(serialized_user[:confirmed_at]).to eq(user.confirmed_at)
    end

    it 'renders the user email' do
      expect(serialized_user[:email]).to eq(user.email)
    end

    it 'renders the user firstname' do
      expect(serialized_user[:firstname]).to eq(user.firstname)
    end

    it 'renders the user lastname' do
      expect(serialized_user[:lastname]).to eq(user.lastname)
    end

    it 'renders the user role' do
      expect(serialized_user[:role]).to eq(user.role)
    end

    it 'renders the user created_at' do
      expect(serialized_user[:created_at]).to eq(user.created_at.strftime('%d/%m/%Y'))
    end
  end
end
