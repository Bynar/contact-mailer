namespace :mailgun do
  desc "Pull Mailgun data to CSV"
  task :pull => :environment do
    require 'csv'
    require 'json'
    require 'uri'
    require 'cgi'

    COLUMNS = %w(timestamp ip recipient recipient-domain event)

    #production
    API_KEY = ENV['MAILGUN_API']

    mg_client = Mailgun::Client.new API_KEY

    # Define the domain you wish to query
    domain = "perspectivo.com"
    page = 0
    next_page = ''
    headers = COLUMNS
    CSV.open("mailgun.csv", "w") do |csv|
      csv << headers
    end

    begin

      puts "Sending GET request to Mailgun API..."
      puts "page: #{page}"

      # Issue the get request
      url = page.zero? ? "#{domain}/events?limit=300" : next_page

      hash = mg_client.get(url).to_h

      next_page = hash['paging']['next']
      puts 'next: ' + next_page.to_s

      results = hash['items']
      puts "results: #{results.size}"

      puts "Writing CSV..."

      CSV.open("mailgun.csv", "ab") do |csv|
        results.each do |event_hash|
          csv <<  headers.map { |key|
            event_hash[key].to_s
          }
        end
      end

      next_page = next_page.gsub(/^https:\/\/api.mailgun.net\/v2\//,'')
      page+=1
    end until results.size == 0
  end
end
