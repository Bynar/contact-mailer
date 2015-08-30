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

  desc "store contacts as csv"
  task save_with_filter: :environment do
    require 'csv'
    file = ENV["contacts_file"] || 'contacts.csv'
    filter = ENV["filter_file"] || 'filters.csv'
    number = ENV["number"].nil? ? nil : ENV["number"].to_i
    date = ENV["created_date"]

    patterns = CSV.read(filter)

    patterns.each do |p_row|
      CSV.open(file, 'ab') do |csv|
        Contact.joins('inner join twitterers on contacts.website = twitterers.real_url')
            .select('contacts.full_name, contacts.website, contacts.email, contacts.context, contacts.form, twitterers.followers_count')
            .where('contacts.created_at >= ?', DateTime.parse(date))
            .where('twitterers.followers_count < ?', 3000)
            .where('contacts.full_name is not null').each do |r| # write results

          pattern = p_row[0]

          if r.email && r.email.match(/#{pattern}/i)
            cleaned_email = EmailCleaner.clean(r.email)
            csv << [r.full_name, r.website,  r.email, cleaned_email, r.context, r.form, r.followers_count]
          end
        end
      end
    end
  end

  desc "store contacts as csv"
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
