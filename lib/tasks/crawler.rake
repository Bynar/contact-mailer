namespace :crawler do
  desc "TODO"
  task crawl: :environment do
  end

  desc "store contacts onto db"
  task store: :environment do
    require 'csv'
    contacts = CSV.read('results.csv', "r:ISO-8859-1")
    contacts.each do |contact|
    #   TODO: process contact
    end

  end

end
