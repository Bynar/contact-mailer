namespace :mailer do
  desc "send  email from leads"
  task send: :environment do
    size = ENV["size"] || 2000
    template = ENV["template"] || 'test'
    MAILER = MailerWorker

    Lead.unsent.with_template(template).first(size).each do |l|
      begin
        MAILER.new.perform(l, template)
        p 'sending mail: ' + l.email.to_s
      rescue Exceptions::MailerAddressConflict  => e
        p 'cannot send mail: ' + e.message.to_s
      rescue ActionView::MissingTemplate
        p 'template ' + template +' not found'
      else
        l.update_attributes(mandrill_sent_date: Time.current)
      end
    end
  end

end
