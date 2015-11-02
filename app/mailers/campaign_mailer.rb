class CampaignMailer < ActionMailer::Base
  default from: (Rails.application.config.email_sender || "mike@perspectivo.com")
  SUBJECT = (Rails.application.config.email_subject || 'Invitation to Perspectivo')
  S2 = "Invitation to check out Perspectivo. It's different but it's cool."
  S3 = "Invitation to check out Perspectivo, you just might love it!"

  def campaign_email(lead, template_name)
    @lead = lead
    if !@lead.unsent? then raise Exceptions::MailerAddressConflict, "#{@lead.email} already sent to previously" end

    mail(to: @lead.email, subject: subject(template_name), template_name: template_name)
  end

private

  def subject(template_name)
    if (template_name.match(/S2/))
      return S2
    elsif (template_name.match(/S3/))
      return S3
    else
      return SUBJECT
    end
  end
end
