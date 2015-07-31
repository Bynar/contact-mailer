namespace :crawler do
  desc "TODO"
  task crawl: :environment do
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

  desc "send mandril email from leads"
  task leads: :environment do
    size = ENV["size"] || 2000
    mandrill_template = ENV["mandrill_template"] || 'test'

    Lead.select{ |l| l.mandrill_template == mandrill_template }.first(size).each do |l|

      MandrillWorker.new.perform(mandrill_template,
                                 [],
                                 MandrillService.message(l))

      l.update_attributes(mandrill_sent_date: Time.current)
    end
  end

end
