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
          raw_email: c[0].downcase,
          # TODO: need to add website
          email: c[0].downcase,
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
    reject_file = 'load_results.csv'

    file = ENV["file"] || 'contacts.csv'
    default_sent_date = ENV["date"].nil? ? nil : DateTime.parse(ENV["date"])
    default_template = ENV["template"]
    number = ENV["number"]|| nil
    created_at = DateTime.now

    contacts = CSV.read(file, "r:ISO-8859-1")

    FIRST_ROW = ['First Name', 'Website', 'Email', 'Sent Date', 'Template']
    contacts.slice!(0) if FIRST_ROW.include? contacts[0][0]
    contacts = contacts.first(number.to_i) unless number.nil?
    contacts.each do |contact|

      first_name = NameService.first_name(contact[0])
      last_name = NameService.last_name(contact[0])

      raw_email = contact[2].downcase
      # email = contact[2].downcase #for loading
      email = raw_email.sub(contact[1].match(/^.*%20/).to_s,'')
      website = contact[1] #TODO: add downcase for all website too
      mandrill_sent_date = contact[5].nil? ? nil : DateTime.parse(mandrill_sent_date)
      mandrill_template = contact[6]


      if Lead.where(low_email: email).blank? &&
          Lead.where(low_raw_email: raw_email).blank? &&
          ( Lead.where(website: website).blank? || !mandrill_sent_date.nil? ) #past records ok

        lead = Lead.create(
            {
                first_name: first_name,
                last_name: last_name,
                raw_email: raw_email,
                email:  email,
                website: website,
                created_at: created_at,
                mandrill_sent_date: mandrill_sent_date || default_sent_date,
                mandrill_template: mandrill_template || default_template
            }
        )
        # lead = Lead.create(
        #     {
        #         # first_name: contact[1],
        #         # last_name: contact[2],
        #         raw_email: contact[0],
        #         # website: contact[4],
        #         email:  contact[0],
        #         mandrill_sent_date:  sent_date ,
        #         mandrill_template:  mandrill_template
        #     }
        # )
      else
        p 'Leads already contains a record with that email: ' + raw_email
        CSV.open(reject_file, 'ab') do |csv|
          csv << [raw_email]
        end
      end

    end
  end
end
