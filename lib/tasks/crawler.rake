namespace :crawler do
  desc "TODO"
  task crawl: :environment do
  end

  desc "store contacts onto db"
  task store: :environment do
    require 'csv'
    contacts = CSV.read('results.csv', "r:ISO-8859-1")
    contacts.each do |contact|
      Contact.create(full_name: contact[0], email: contact[2], website: contact[1], form: contact[4], context: contact[3])
    end
  end

  desc "load contacts into leads"
  task leads: :environment do
    size = ENV["size"] || 2000
    mandrill_template = ENV["mandrill_template"] || 'test'

    Contact.select{ |c| !c.email.nil? && c.lead_id.nil? }.first(size).each do |c|
      lead = Lead.create(
        first_name: c.first_name,
        last_name: c.last_name,
        email: c.email,
        mandrill_template: mandrill_template )

      c.update_attributes(lead_id: lead.id)
    end
  end

end
