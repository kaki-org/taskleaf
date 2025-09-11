# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'validations' do
    context 'when validating name' do
      it 'is valid with a name' do
        contact = build(:contact, name: 'John Doe')
        expect(contact).to be_valid
      end

      it 'is invalid without a name' do
        contact = build(:contact, name: nil)
        expect(contact).not_to be_valid
        expect(contact.errors[:name]).to include('を入力してください')
      end

      it 'is invalid with empty name' do
        contact = build(:contact, name: '')
        expect(contact).not_to be_valid
        expect(contact.errors[:name]).to include('を入力してください')
      end
    end

    context 'when validating email' do
      it 'is valid with a proper email format' do
        contact = build(:contact, email: 'test@example.com')
        expect(contact).to be_valid
      end

      it 'is invalid without an email' do
        contact = build(:contact, email: nil)
        expect(contact).not_to be_valid
        expect(contact.errors[:email]).to include('を入力してください')
      end

      it 'is invalid with empty email' do
        contact = build(:contact, email: '')
        expect(contact).not_to be_valid
        expect(contact.errors[:email]).to include('を入力してください')
      end

      it 'is invalid with malformed email' do
        contact = build(:contact, email: 'invalid-email')
        expect(contact).not_to be_valid
        expect(contact.errors[:email]).to include('は不正な値です')
      end

      it 'is invalid with email missing @ symbol' do
        contact = build(:contact, email: 'testexample.com')
        expect(contact).not_to be_valid
        expect(contact.errors[:email]).to include('は不正な値です')
      end

      it 'is invalid with email missing domain' do
        contact = build(:contact, email: 'test@')
        expect(contact).not_to be_valid
        expect(contact.errors[:email]).to include('は不正な値です')
      end
    end
  end

  describe 'factory' do
    it 'creates a valid contact' do
      contact = create(:contact)
      expect(contact).to be_valid
      expect(contact.name).to be_present
      expect(contact.email).to be_present
    end
  end
end
