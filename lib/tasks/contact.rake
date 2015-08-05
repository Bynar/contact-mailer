namespace :contact do
  desc "store contacts onto db"
  task store: :environment do
    require 'csv'
    file = ENV["contacts_file"] || 'contacts.csv'
    contacts = CSV.read(file, "r:ISO-8859-1")

    FIRST_ROW = ['Name','Website Url','e-mail','e-mail url','contact page URL']
    contacts.slice!(0) if FIRST_ROW.include? contacts[0][0]

    created_at = ENV["created_date"].nil? ? File.mtime(file) : DateTime.parse(ENV["created_date"])

    Contact.create(
      contacts.map do |contact|
        {
          full_name: contact[0],
          website: contact[1],
          email: contact[2],
          context: contact[3],
          form: contact[4],
          created_at: created_at
        }
      end
    )
  end

  desc "store contacts onto db"
  task save: :environment do
    require 'csv'
    file = ENV["contacts_file"] || 'contacts.csv'
    number = ENV["number"] || nil

    CSV.open(file, 'ab') do |csv|
      Contact.limit(number).each do |c| # write results
        csv << [c.full_name, c.website,  c.email, c.context, c.form]
      end
    end
  end
end
