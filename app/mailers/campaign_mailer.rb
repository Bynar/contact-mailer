class CampaignMailer < ActionMailer::Base
  default from: (Rails.application.config.email_sender || "mike@perspectivo.com")

  def campaign_email(lead)
    @lead = lead
    mail(to: @lead.email, subject: 'Sample Email')
  end
end
