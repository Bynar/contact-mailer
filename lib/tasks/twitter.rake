namespace :twitter do

  desc "store twitter contacts onto db"
  task store: :environment do
    require 'csv'
    file = ENV["file"] || 'twitter_contacts.csv'
    crawled_at = ENV["date"].nil? ? DateTime.now : DateTime.parse(ENV["date"])
    FIRST_ROW = %w(id username fullname last_tweet_date description location twitter_url followers_count real_url)

    contacts = CSV.read(file, "r:ISO-8859-1")
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
                       crawled_at: crawled_at
                     }
      end
    )
  end
end
