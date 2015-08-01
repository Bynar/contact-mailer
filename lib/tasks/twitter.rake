namespace :twitter do

  desc "store twitter contacts onto db"
  task store: :environment do
    require 'csv'
    file = ENV["twitterers_file"] || 'twitter_contacts.csv'
    results_file = ENV["contacts_file"] || 'contacts.csv'
    contacts = CSV.read(file, "r:ISO-8859-1")

    crawled_at = ENV["crawled_date"].nil? ? File.mtime(results_file) : DateTime.parse(ENV["crawled_date"])
    created_at = ENV["created_date"].nil? ? File.mtime(file) : DateTime.parse(ENV["created_date"])

    FIRST_ROW = %w(id username fullname last_tweet_date description location twitter_url followers_count real_url)
    contacts.slice!(0) if FIRST_ROW.include? contacts[0][0]

    Twitterer.create(
      contacts.map do |contact|
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
