# frozen_string_literal: true

class Legacy
  def self.move_contact
    User.find_each do |contact|
      Contact.create!(
        name: contact.name,
        email: contact.email
      )
    end
  end
end
