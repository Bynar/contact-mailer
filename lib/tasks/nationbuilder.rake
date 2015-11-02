namespace :nationbuilder do
  desc "Pull Nationbuilder to CSV"
  task :pull => :environment do
    require 'nationbuilder'
    require 'csv'
    require 'json'
    require 'uri'
    require 'cgi'


    #production
    API_KEY = ENV['NATIONBUILDER_API']

    client = NationBuilder::Client.new('perspectivo', API_KEY)

    params = {
        limit: 100
    }
    results=[]

    begin

      puts "Sending GET request to Mixpanel API..."
      puts "Params: #{params}"
      hash = client.call(:people, :index, params.to_hash)

      next_page = hash['next']
      previous_page = hash['prev']

      puts 'next: ' + next_page.to_s

      puts "Writing CSV..."
      CSV.open("national_people.csv", "ab") do |csv|
        results = hash['results']
        puts "results: #{results.size}"

        headers = results.map {|people_hash| people_hash.keys.map(&:to_s) }.flatten.uniq
        csv << headers if previous_page.nil?

        results.each do |people_hash|
          csv <<  headers.map { |key|
            people_hash[key].to_s
          }
        end
      end

      if next_page
        next_params = CGI.parse(URI.parse(next_page).query)
        params[:__nonce] = next_params["__nonce"][0]
        params[:__token] = next_params["__token"][0]
      end

    end until next_page.nil?
  end

  task :tags => :environment do
    require 'nationbuilder'
    require 'csv'
    require 'json'
    require 'uri'
    require 'cgi'

    tag = ENV['tag']

    #production
    API_KEY = ENV['NATIONBUILDER_API']

    client = NationBuilder::Client.new('perspectivo', API_KEY)

    params = {
        tag: tag,
        limit: 100
    }
    results=[]

    begin

      puts "Sending GET request to Mixpanel API..."
      puts "Params: #{params}"
      results = client.call(:people_tags, :people, params.to_hash)

      page ||= NationBuilder::Paginator.new(client, results)

      puts "Writing CSV..."
      CSV.open("national_tags.csv", "ab") do |csv|
        results = page.body['results']
        puts "results: #{results.size}"

        headers = results.map {|people_hash| people_hash.keys.map(&:to_s) }.flatten.uniq
        csv << headers if page.prev.nil?

        results.each do |people_hash|
          csv <<  headers.map { |key|
            people_hash[key].to_s
          }
        end
      end

      page = page.next

    end until page.nil?
  end
end