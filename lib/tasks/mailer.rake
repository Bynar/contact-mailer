namespace :mailer do
  desc "send email from leads"
  task send: :environment do
    size = ENV["size"] || 2000
    template = ENV["template"] || 'test'

    MailerService.send(size, template, MailerWorker)
  end

  desc "load emails from leads"
  task load: :environment do
    size = ENV["size"] || 500
    pool = ENV["pool"] || 'undecided'
    templates = ENV["templates"] || 'test'

    p "templates: #{templates}"

    templates = templates.split(' ')

    p "templates: #{templates[0]}"

    templates.each do |template|
      leada=Lead.unsent.with_template(pool).first(size)
      leada.each{|l| l.update_attribute(:mandrill_template, template)}
    end
  end
end
