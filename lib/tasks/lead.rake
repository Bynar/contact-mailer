namespace :lead do
  desc "load contacts into leads"
  task store: :environment do
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
