require 'legacy'
namespace :move_contact do
  desc "Move user to contacts"
  task user: :environment do
    Legacy.move_contact
  end
end
