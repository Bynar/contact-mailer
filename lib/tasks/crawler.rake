namespace :crawler do
  desc "Crawl twitter data"
  task crawl: :environment do
    Rake.application.rake_require "#{Rails.root}/lib/contact-crawler"

    LINK_LIMIT = 20
    CRAWL_LIMIT = 2000
    crawled_at = DateTime.now

    Result.WRITER = ContactWriter

    Twitterer.not_crawled.limit(CRAWL_LIMIT).each do |tw|
      tw.update_attributes(crawled_at: crawled_at)
      ContactCrawler.crawl(tw.real_url, UrlCleaner.friendly(tw.real_url), nil, LINK_LIMIT, tw.fullname)
    end
  end

  task store: :environment do
    Rake::Task['twitter:store'].invoke
    Rake::Task['contact:store'].invoke
  end
end
