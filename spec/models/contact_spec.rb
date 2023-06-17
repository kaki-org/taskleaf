# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'create contact' do
    it 'should create contact' do
      contact = Contact.new
      contact.name = 'test'
      contact.email = 'test@example.com'
      contact.save
      expect(contact).to be_valid
    end
  end
end
