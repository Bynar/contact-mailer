namespace :twitter do

  desc "store twitter contacts onto db"
  task store: :environment do
    require 'csv'

    FIRST_ROW = %w(id username fullname last_tweet_date description location twitter_url followers_count real_url)

    files = Dir["/Users/Admin/pt/process/twitterers/*.csv"]

    files.each do |file|

      twitterers = CSV.read(file, "r:ISO-8859-1")

      num = file.match(/[0-9]+/).to_s
      results_file = "/Users/Admin/pt/process/results/results#{num}.csv"

      date = file.match(/[0-9\-_]+\.csv/).to_s
      date[0]=''
      date.sub!('.csv', '')

      p results_file;
      p date;

      begin
        created_at = DateTime.strptime(date, '%Y-%m-%d_%H-%M-%S')
      rescue ArgumentError
        created_at = DateTime.strptime(date, '%Y-%m-%d_%H_%M_%S')
      end

      crawled_at = ENV["crawled_date"].nil? ? File.mtime(results_file) : DateTime.parse(ENV["crawled_date"])

      twitterers.slice!(0) if FIRST_ROW.include? twitterers[0][0]

      Twitterer.create(
          twitterers.map do |contact|
                       {
                         twitter_id: contact[0],
                         username: contact[1],
                         fullname: contact[2],
                         last_tweet_date: contact[3],
                         description: contact[4],
                         location: contact[5],
                         twitter_url: contact[6],
                         followers_count: contact[7],
                         real_url: contact[8],
                         crawled_at: crawled_at,
                         created_at: created_at
                       }
        end
      )
    end
  end
end
