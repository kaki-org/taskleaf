# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact do
  describe 'validations' do
    subject { build(:contact) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }

    describe 'email format validation' do
      it 'accepts valid email addresses' do
        valid_emails = [
          'user@example.com',
          'test.email@example.co.jp',
          'user+tag@example.org'
        ]

        valid_emails.each do |email|
          contact = build(:contact, email: email)
          expect(contact).to be_valid, "#{email} should be valid"
        end
      end

      it 'rejects invalid email addresses' do
        invalid_emails = [
          'invalid_email',
          'user@',
          '@example.com',
          'user space@example.com'
        ]

        invalid_emails.each do |email|
          contact = build(:contact, email: email)
          expect(contact).not_to be_valid, "#{email} should be invalid"
          expect(contact.errors[:email]).to include('は不正な値です')
        end
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:contact)).to be_valid
    end
  end
end
