# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#admin?' do
    context 'when admin is true' do
      it 'returns true' do
        user = build(:admin)
        expect(user).to be_admin
      end
    end

    context 'when admin is false' do
      it 'returns false' do
        user = build(:user)
        expect(user).not_to be_admin
      end
    end

    context 'when admin is nil' do
      it 'returns false' do
        user = build(:user, admin: nil)
        expect(user).not_to be_admin
      end
    end
  end

  describe 'factory validation' do
    it 'creates a valid admin user' do
      admin = create(:admin)
      expect(admin).to be_valid
      expect(admin).to be_admin
    end

    it 'creates a valid regular user' do
      user = create(:user)
      expect(user).to be_valid
      expect(user).not_to be_admin
    end
  end
end