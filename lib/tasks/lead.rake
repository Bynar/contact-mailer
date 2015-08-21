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
          # TODO: need to add website
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

    FIRST_ROW = ['First Name', 'Website', 'Email', 'Sent Date', 'Template']
    contacts.slice!(0) if FIRST_ROW.include? contacts[0][0]
    contacts = contacts.first(number.to_i) unless number.nil?
    contacts.each do |contact|

      # lead = Lead.new(
      #     {
      #         first_name: contact[1],
      #         last_name: contact[2],
      #         raw_email: contact[3],
      #         website: contact[4],
      #         email:  contact[3],
      #         mandrill_sent_date: contact[5].nil? ? sent_date : DateTime.parse(contact[5]),
      #         mandrill_template: contact[6] || mandrill_template
      #     }
      # )
      lead = Lead.new(
          {
              first_name: NameService.first_name(contact[0]),
              last_name: NameService.last_name(contact[0]),
              raw_email: contact[2],
              website: contact[1],
              email:  contact[3].sub(contact[1].match(/^.*%20/).to_s,''),
              # mandrill_sent_date: contact[3].nil? ? sent_date : DateTime.parse(contact[3]),
              mandrill_template: mandrill_template
          }
      )

      if Lead.where(email: lead.email).blank? &&
          Lead.where(raw_email: lead.raw_email).blank? &&
          ( Lead.where(website: lead.website).blank? || !lead.mandrill_sent_date.nil? )
        lead.save
      else
        p 'Leads already contains a record with that email: ' + lead.email.to_s
      end

    end
  end
end
