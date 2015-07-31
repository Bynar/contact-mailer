namespace :contact do
  desc "store contacts onto db"
  task store: :environment do
    require 'csv'
    file = ENV["file"] || 'results.csv'
    contacts = CSV.read(file, "r:ISO-8859-1")

    FIRST_ROW = ['Name','Website Url','e-mail','e-mail url','contact page URL']
    contacts.slice!(0) if FIRST_ROW.include? contacts[0][0]

    Contact.create(
      contacts.map do |contact|
        {
          full_name: contact[0],
          website: contact[1],
          email: contact[2],
          context: contact[3],
          form: contact[4]
        }
      end
    )
  end
end
