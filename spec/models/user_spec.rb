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

  describe 'sleep type methods' do
    let(:user) { create(:user) }

    # Création des sleeps de différents types dans un before
    before do
      @dream1 = create(:sleep, user: user, sleep_type: Sleep::SLEEP_TYPE[:dream])
      @dream2 = create(:sleep, user: user, sleep_type: Sleep::SLEEP_TYPE[:dream])
      @nightmare = create(:sleep, user: user, sleep_type: Sleep::SLEEP_TYPE[:nightmare])
      @lucid = create(:sleep, user: user, sleep_type: Sleep::SLEEP_TYPE[:lucid])
      @paralysis = create(:sleep, user: user, sleep_type: Sleep::SLEEP_TYPE[:sleep_paralysis])
      @walking = create(:sleep, user: user, sleep_type: Sleep::SLEEP_TYPE[:sleep_walking])
      @talking = create(:sleep, user: user, sleep_type: Sleep::SLEEP_TYPE[:sleep_talking])
      @apnea = create(:sleep, user: user, sleep_type: Sleep::SLEEP_TYPE[:sleep_apnea])
      @erotic = create(:sleep, user: user, sleep_type: Sleep::SLEEP_TYPE[:erotic])
      @other_user_dream = create(:sleep, sleep_type: Sleep::SLEEP_TYPE[:dream])
    end

    describe '#dreams' do
      it 'returns only dreams for the user' do
        expect(user.dreams).to contain_exactly(@dream1, @dream2)
      end

      it 'returns an ActiveRecord::Relation' do
        expect(user.dreams).to be_a(ActiveRecord::Relation)
      end

      it 'does not include dreams from other users' do
        expect(user.dreams).not_to include(@other_user_dream)
      end

      it 'returns empty collection when user has no dreams' do
        user.dreams.destroy_all
        expect(user.dreams).to be_empty
      end
    end

    describe '#nightmares' do
      it 'returns only nightmares for the user' do
        expect(user.nightmares).to contain_exactly(@nightmare)
      end

      it 'does not include other sleep types' do
        expect(user.nightmares).not_to include(@dream1, @lucid)
      end
    end

    describe '#lucids' do
      it 'returns only lucid dreams for the user' do
        expect(user.lucids).to contain_exactly(@lucid)
      end
    end

    describe '#paralyses' do
      it 'returns only sleep paralyses for the user' do
        expect(user.paralyses).to contain_exactly(@paralysis)
      end
    end

    describe '#walkings' do
      it 'returns only sleep walkings for the user' do
        expect(user.walkings).to contain_exactly(@walking)
      end
    end

    describe '#talkings' do
      it 'returns only sleep talkings for the user' do
        expect(user.talkings).to contain_exactly(@talking)
      end
    end

    describe '#apneas' do
      it 'returns only sleep apneas for the user' do
        expect(user.apneas).to contain_exactly(@apnea)
      end
    end

    describe '#erotics' do
      it 'returns only erotic dreams for the user' do
        expect(user.erotics).to contain_exactly(@erotic)
      end
    end

    describe 'chainability' do
      it 'allows chaining with other ActiveRecord methods' do
        create(:sleep,
               user: user,
               sleep_type: Sleep::SLEEP_TYPE[:dream],
               created_at: 1.day.ago)

        expect(user.dreams.order(created_at: :desc).first).to eq(@dream2)
      end

      it 'allows counting' do
        expect(user.dreams.count).to eq(2)
      end

      it 'allows limiting results' do
        expect(user.dreams.limit(1).size).to eq(1)
      end
    end

    describe 'query efficiency' do
      it 'generates a single SQL query' do
        expect { user.dreams.to_a }.to make_database_queries(count: 1)
      end
    end

    describe 'method existence' do
      it { is_expected.to respond_to(:dreams) }
      it { is_expected.to respond_to(:nightmares) }
      it { is_expected.to respond_to(:lucids) }
      it { is_expected.to respond_to(:paralyses) }
      it { is_expected.to respond_to(:walkings) }
      it { is_expected.to respond_to(:talkings) }
      it { is_expected.to respond_to(:apneas) }
      it { is_expected.to respond_to(:erotics) }
    end
  end
end
