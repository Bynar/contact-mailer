namespace :lead do

  desc "load contacts into leads table"
  task generate: :environment do
    size = (ENV["size"]|| '2000').to_i
    mandrill_template = ENV["mandrill_template"] || 'test'

    Lead.create(
      Contact.full_name_uniq_emails_not_in_leads.first(size)
          .map do |c|
        {
          first_name: NameService.first_name(c[1]),
          last_name: NameService.last_name(c[1]),
          raw_email: c[0],
          email: c[0],
          mandrill_template: mandrill_template
        }
      end
    )

    Rake::Task['lead:save'].invoke
  end

  desc "save leads to csv"
  task save: :environment do
    require 'csv'

    mandrill_template = ENV["mandrill_template"] || 'test'
    file = ENV["file"] || 'leads.csv'

    leads = Lead.where(mandrill_template: mandrill_template)

    CSV.open(file, 'ab') do |csv|
      leads.each do |l| # write results
        csv << [l.first_name, l.last_name, l.email]
      end
    end

  end

  desc "store leads onto db"
  task store: :environment do
    require 'csv'
    file = ENV["file"] || 'contacts.csv'
    sent_date = ENV["date"].nil? ? nil : DateTime.parse(ENV["date"])
    mandrill_template = ENV["mandrill_template"]
    number = ENV["number"]|| nil


    contacts = CSV.read(file, "r:ISO-8859-1")

    FIRST_ROW = ['First Name', 'Last Name', 'Email', 'Sent Date']
    contacts.slice!(0) if FIRST_ROW.include? contacts[0][0]
    contacts = contacts.first(number.to_i) unless number.nil?


    Lead.create(
        contacts.map do |contact|
          {
              first_name: contact[0],
              last_name: contact[1],
              email: contact[2],
              mandrill_sent_date: contact[3].nil? ? sent_date : DateTime.parse(contact[3]),
              mandrill_template: contact[4] || mandrill_template
          }
        end
    )
  end
end
