namespace :mandrill do
  desc "send mandrill email from leads"
  task send: :environment do
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
