namespace :crawler do
  desc "TODO"
  task crawl: :environment do
  end

  task store: :environment do
    Rake::Task['twitter:store'].invoke
    Rake::Task['contact:store'].invoke
  end
end
