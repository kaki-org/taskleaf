# frozen_string_literal: true

require 'rails_helper'
require 'legacy'

RSpec.describe Legacy, type: :model do
  describe '#move_contact' do
    let!(:users) { FactoryBot.create_list(:user, 10) }

    it 'creates contacts from users' do
      expect { Legacy.move_contact }.to change(Contact, :count).from(0).to(10)
      expect(User.count).to eq(Contact.count)
    end
  end
end
