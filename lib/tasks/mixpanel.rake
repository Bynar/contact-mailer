namespace :mixpanel do
  desc "Pull Mixpanel to CSV"
  task :pull => :environment do
    require 'net/http'
    require 'csv'
    require 'json'

    #production
    API_SECRET = ENV['API_SECRET']
    API_KEY = ENV['API_KEY']
    TIMEOUT = ENV['TIMEOUT'] || 1000 # seconds

    from_date = ENV['from_date'] || 1.year.ago.strftime("%Y-%m-%d")
    to_date = ENV['to_date'] || 1.day.ago.strftime("%Y-%m-%d")

    puts "Sending GET request to Mixpanel API..."
    api_secret = API_SECRET
    params = {
        api_key:    API_KEY,
        expire:     Time.now.to_i + 60,
        from_date:  from_date,
        to_date:    to_date
    }.to_query

    sig = Digest::MD5.hexdigest(params.gsub(/&/, "") + api_secret)
    puts "Params: #{params}"
    uri = URI.parse("http://data.mixpanel.com/api/2.0/export?#{params}&sig=#{sig}")
    req = Net::HTTP::Get.new(uri.to_s)
    res = Net::HTTP.start(uri.host, uri.port, read_timeout: TIMEOUT) {|http| http.request(req) }
    json = "[#{res.body.gsub(/\n/, ", ")[0..-3]}]"

    puts "Writing CSV..."
    CSV.open("mixpanel.csv", "w") do |csv|
      hash = JSON.parse(json)
      headers = hash.map {|row| row["properties"].keys.map(&:to_s) }.flatten.uniq
      csv << ["event"] + headers
      hash.each do |event|
        csv << [event["event"]] + headers.map { |col|
          col == "time" ? Time.at(event["properties"][col].to_i).strftime("%Y-%m-%d %H:%M:%S") : event["properties"][col].to_s
        }
      end
    end
  end

  desc "Pull Mixpanel People to CSV"
  task :engage => :environment do
    require 'net/http'
    require 'csv'
    require 'json'

    #production
    API_SECRET = ENV['API_SECRET']
    API_KEY = ENV['API_KEY']

    puts "Sending GET request to Mixpanel API..."
    api_secret = API_SECRET
    params = {
        api_key:    API_KEY,
        expire:     Time.now.to_i + 60,
    }
    results=[]

    begin
      query = params.to_query
      sig = Digest::MD5.hexdigest(query.gsub(/&/, "") + api_secret)
      puts "Params: #{query}"
      uri = URI.parse("http://mixpanel.com/api/2.0/engage?#{query}&sig=#{sig}")
      req = Net::HTTP::Get.new(uri.to_s)
      res = Net::HTTP.start(uri.host, uri.port) {|http| http.request(req) }
      json = res.body
      hash = JSON.parse(json)
      page = hash['page']
      page_size ||= hash['page_size']
      session_id = hash['session_id']

      puts 'page: ' + page.to_s
      puts 'page_size: ' + page_size.to_s

      puts "Writing CSV..."
      CSV.open("mixpanel_people.csv", "ab") do |csv|
        results = hash['results']
        puts "results: #{results.size}"

        headers = results.map {|row| row["$properties"].keys.map(&:to_s) }.flatten.uniq
        csv << ["distinct_id"] + headers if page == 0

        results.each do |person|
          csv << [person["$distinct_id"]] + headers.map { |col|
            person["$properties"][col].to_s
          }
        end
      end

      params[:page] = page+1
      params[:session_id] = session_id
    end until results.length < page_size
  end
end