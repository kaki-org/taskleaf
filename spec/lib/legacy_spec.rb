# frozen_string_literal: true

require 'rails_helper'
require 'legacy'

describe Legacy do
  let!(:users) do
    10.times do
      FactoryBot.create(:user)
    end
  end
  it 'userからcontactを作成すること' do
    Legacy.move_contact
    expect(User.count).to eq Contact.count
    expect(Contact.count).to eq 10 # 10.timesで作成したので
  end
end
