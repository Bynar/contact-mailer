class CampaignMailer < ActionMailer::Base
  default from: (Rails.application.config.email_sender || "mike@perspectivo.com")
  SUBJECT = (Rails.application.config.email_subject || 'Invitation to Perspectivo')

  def campaign_email(lead, template_name)
    @lead = lead
    if !@lead.unsent? then raise Exceptions::MailerAddressConflict, "#{@lead.email} already sent to previously" end

    mail(to: @lead.email, subject: SUBJECT, template_name: template_name)
  end
end
