namespace :mailer do
  desc "send  email from leads"
  task send: :environment do
    size = ENV["size"] || 2000
    template = ENV["template"] || 'test'
    MAILER = MailerWorker

    Lead.select{ |l| l.mandrill_template == template }.first(size).each do |l|

      MAILER.new.perform(l)

      l.update_attributes(mandrill_sent_date: Time.current)
    end
  end

end
