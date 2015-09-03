class MailerService

  def self.send(size, template, mailer)
    Lead.unsent.with_template(template).first(size).each do |l|
      begin
        mailer.new.perform(l, template)
        p 'sending mail: ' + l.email.to_s
      rescue Exceptions::MailerAddressConflict => e
        p 'cannot send mail: ' + e.message.to_s
      rescue ActionView::MissingTemplate
        p 'template ' + template +' not found'
      else
        l.update_attributes(mandrill_sent_date: Time.current)
      end
    end
  end
end
