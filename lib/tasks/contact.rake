namespace :contact do
  desc "store contacts onto db"
  task store: :environment do
    require 'csv'

    #default date overrides the create date of the input file
    default_date = DateTime.parse(ENV["created_date"]) unless ENV["created_date"].nil?

    files = Dir["/Users/Admin/pt/process/results/*.csv"]

    ContactStorer.store(default_date, files)
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
