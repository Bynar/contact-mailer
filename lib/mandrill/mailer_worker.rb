require 'mandrill'

class MandrillWorker

  LOG = "MandrillWorker: ".freeze

  def perform(template, template_content, message)
    log("Sending Email")

    raise ArgumentError if template.blank?

    result = send(template, template_content, message)

  rescue Mandrill::Error => e
      err_log err_msg(e)
      raise Exceptions::ServiceUnavailable, err_msg(e)
  ensure
    log(result.inspect)
  end

  def log(msg)
    Rails.logger.info(LOG + msg)
  end

  def err_log(msg)
    Rails.logger.error(LOG + msg)
  end

  def err_msg(e)
    "#{e.class}: #{e.message}"
  end

  def api
    Mandrill::API.new(Rails.application.config.mandrill_api)
  end

  def send(*args)
    api.messages.send_template(args)
  end
end
