# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'filter name by letter' do
    before do
      @smith = create(:user, name: 'Smith')
      @jones = create(:user, name: 'Jones')
      @johnson = create(:user, name: 'Johnson')
    end

    context 'when matching letters' do
      it 'returns a sorted array of results that match' do
        expect(User.by_letter('J')).to eq [@johnson, @jones]
      end
    end

    context 'when non-matching letters' do
      it 'does not return users that do not match' do
        expect(User.by_letter('J')).not_to include @smith
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end
end
