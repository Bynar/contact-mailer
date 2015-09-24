class MailerService

  def self.send(size, template, mailer)

    # tracker = Mixpanel::Tracker.new(Rails.application.config.mixpanel_api)

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
        # track(tracker, l, template)
      end
    end
  end

  def self.track(tracker, lead, template)
    # Track an event on behalf of user "User1"
    tracker.track(lead.email, 'Invitation Sent', template: template)

    # Send an update to User1's profile
    tracker.people.set(lead.email, {
                                  '$first_name' => lead.first_name,
                                  '$last_name' => lead.last_name,
                                  '$email' => lead.email,
                                  website: lead.website
                              })
  end
end
