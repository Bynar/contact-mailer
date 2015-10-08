require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ContactMailerPrototype
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.email_sender = ENV["EMAIL_SENDER"]
    config.email_subject = ENV["EMAIL_SUBJECT"]

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Sending via Direct SMTP
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :address              => "smtp.mailgun.org",
        :port                 => 587,
        # :domain               => 'perspectivo.com',
        # :authentication       => 'plain',
        # :enable_starttls_auto => true  }
        :user_name            => ENV["MAIL_USER_NAME"],
        :password             => ENV["MAIL_API_KEY"] }

    # Sending via Mailjet
    # config.action_mailer.delivery_method = :mailjet
    # config.mailjet_api_key = ENV["MAILJET_API"]
    # config.mailjet_secret_key = ENV["MAILJET_SECRET_KEY"]

    config.mixpanel_api = ENV["MIXPANEL_API"]
  end
end
