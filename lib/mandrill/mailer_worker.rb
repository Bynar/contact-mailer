class MailerWorker

  LOG = "Mailerworker: ".freeze

  def perform(lead)
    log("Sending Email")

    result = send(lead)

    log(result.inspect)
  end

private

  def log(msg)
    Rails.logger.info(LOG + msg)
  end

  def err_log(msg)
    Rails.logger.error(LOG + msg)
  end

  def send(lead)
  # Sends email to user when user is created.
    CampaignMailer.campaign_email(lead).deliver
  end
end
