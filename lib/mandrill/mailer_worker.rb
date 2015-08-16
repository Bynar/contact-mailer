class MailerWorker

  LOG = "Mailerworker: ".freeze

  def perform(lead, template)
    log("Sending Email")

    result = send(lead, template)

    log(result.inspect)
  end

private

  def log(msg)
    Rails.logger.info(LOG + msg)
  end

  def err_log(msg)
    Rails.logger.error(LOG + msg)
  end

  def send(lead, template)
    mail = CampaignMailer.campaign_email(lead, template)
    mail.deliver
  end
end
