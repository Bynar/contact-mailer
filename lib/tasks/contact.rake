namespace :contact do
  desc "store contacts onto db"
  task store: :environment do
    require 'csv'

    files = Dir["/Users/Admin/pt/process/results/*.csv"]
    FIRST_ROW = ['Name','Website Url','e-mail','e-mail url','contact page URL']

    files.each do |file|

      contacts = CSV.read(file, "r:ISO-8859-1")

      contacts.slice!(0) if FIRST_ROW.include? contacts[0][0]

      contacts.reject!{|c| c[1].nil? }

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
  end

  desc "save filtered contacts as csv"
  task save_with_filter: :environment do
    require 'csv'
    file = ENV["contacts_file"] || 'contacts.csv'
    filter = ENV["filter_file"] || 'filters.csv'
    limit = ENV["number"].nil? ? nil : ENV["number"].to_i
    date = ENV["cutoff"]

    ContactSaver.save_with_filter(date, file, filter, limit)
  end

  desc "save contacts as csv"
  task save: :environment do
    require 'csv'
    file = ENV["contacts_file"] || 'contacts.csv'
    number = ENV["number"].nil? ? nil : ENV["number"].to_i

    CSV.open(file, 'w') do |csv|

      Contact.limit(number).each do |c|
        csv << [c.full_name, c.website,  c.email, c.context, c.form]
      end
    end
  end

end
