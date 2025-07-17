# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagSerializer do
  let(:user) { create(:user) }
  let(:sleep) { create(:sleep, user:) }
  let(:tag) { create(:tag, sleep_id: sleep.id) }
  let(:serialized_tag) { described_class.render_as_hash(tag) }

  it 'renders the correct id' do
    expect(serialized_tag[:id]).to eq(tag.id)
  end

  it 'renders the correct tag name' do
    expect(serialized_tag[:name]).to eq(tag.name)
  end
end
