class CampaignMailer < ActionMailer::Base
  default from: (Rails.application.config.email_sender || "mike@perspectivo.com")
  SUBJECT = (Rails.application.config.email_subject || 'Invitation to Perspectivo')

  def campaign_email(lead)
    @lead = lead
    mail(to: @lead.email, subject: SUBJECT)
  end
end
