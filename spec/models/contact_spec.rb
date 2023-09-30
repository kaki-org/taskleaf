# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'create contact' do
    let(:contact) { Contact.create(name: 'test', email: 'test@example.com') }

    it 'should create contact' do
      expect(contact).to be_valid
    end
  end
end
