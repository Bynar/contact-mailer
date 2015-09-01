namespace :lead do

  desc "load contacts into leads table"
  task generate: :environment do
    size = (ENV["size"]|| '2000').to_i
    mandrill_template = ENV["mandrill_template"] || 'test'

    Lead.create(
      Contact.full_name_uniq_emails_not_in_leads.first(size) # TODO: add website to scope
          .map do |c|
        {
          first_name: NameService.first_name(c[1]),
          last_name: NameService.last_name(c[1]),
          raw_email: c[0],
          # TODO: add website
          email: c[0].downcase, # TODO: clean email
          mandrill_template: mandrill_template
        }
      end
    )

    Rake::Task['lead:save'].invoke
  end

  desc "save leads to csv"
  task save: :environment do
    require 'csv'

    mandrill_template = ENV["mandrill_template"] || 'test'
    file = ENV["file"] || 'leads.csv'

    leads = Lead.where(mandrill_template: mandrill_template)

    CSV.open(file, 'ab') do |csv|
      leads.each do |l| # write results
        csv << [l.first_name, l.last_name, l.email]
      end
    end

  end

  desc "store leads onto db"
  task store: :environment do

    input_file = ENV["file"] || 'contacts.csv'
    default_sent_date = ENV["date"].nil? ? nil : DateTime.parse(ENV["date"])
    default_template = ENV["template"]
    limit = ENV["number"]|| nil
    reject_file = ENV["reject_file"]||'load_results.csv'
    filter_file = ENV["filter_file"] || 'reject_filter.csv'

    LeadService.store(input_file, reject_file, filter_file, default_sent_date, default_template, limit)

  end
end
