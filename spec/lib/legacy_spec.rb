require 'rails_helper'
require 'legacy'

describe Legacy do
  it 'userからcontactを作成すること' do
    Legacy.move_contact
    expect(User.count).to eq Contact.count
  end
end
