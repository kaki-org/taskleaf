# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact do
  describe 'create contact' do
    let(:contact) { described_class.create(name: 'test', email: 'test@example.com') }

    it 'creates contact' do
      expect(contact).to be_valid
    end
  end
end
