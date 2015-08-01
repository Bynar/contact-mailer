namespace :lead do

  desc "load contacts into leads"
  task generate: :environment do
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

  desc "store leads onto db"
  task store: :environment do
    require 'csv'
    file = ENV["file"] || 'contacts.csv'
    contacts = CSV.read(file, "r:ISO-8859-1")

    FIRST_ROW = ['Email', 'First Name', 'Last Name' ]
    contacts.slice!(0) if FIRST_ROW.include? contacts[0][0]

    crawled_at = ENV["date"].nil? ? DateTime.now : DateTime.parse(ENV["date"])

    Lead.create(
        contacts.map do |contact|
          {
              first_name: contact[0],
              last_name: contact[1],
              email: contact[2],
              mandrill_template: contact[3],
              mandrill_sent_date: contact[4] || crawled_at
          }
        end
    )
  end
end
