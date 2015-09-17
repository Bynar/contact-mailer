Mailjet.configure do |config|
  config.api_key = Rails.application.config.mailjet_api_key
  config.secret_key = Rails.application.config.mailjet_secret_key
  config.default_from = 'mike@perspectivo.com'
end