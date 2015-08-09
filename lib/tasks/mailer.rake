namespace :mailer do
  desc "send  email from leads"
  task send: :environment do
    size = ENV["size"] || 2000
    template = ENV["template"] || 'test'

    Lead.select{ |l| l.mandrill_template == template }.first(size).each do |l|

      MandrillWorker.new.perform(template,
                                 [],
                                 MandrillService.message(l))

      l.update_attributes(mandrill_sent_date: Time.current)
    end
  end

end
