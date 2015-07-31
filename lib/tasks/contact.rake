namespace :contact do
  desc "store contacts onto db"
  task store: :environment do
    require 'csv'
    contacts = CSV.read('results.csv', "r:ISO-8859-1")
    contacts.each do |contact|
      Contact.create(full_name: contact[0], email: contact[2], website: contact[1], form: contact[4], context: contact[3])
    end
  end
end
