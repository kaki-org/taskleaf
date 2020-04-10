class Legacy
  def self.move_contact
    User.all.each do |contact|
      Contact.create!(
          name: contact.name,
          email: contact.email
      )
    end
  end
end