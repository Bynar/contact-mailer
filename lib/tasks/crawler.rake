namespace :crawler do
  desc "Crawl twitter data"
  task crawl: :environment do

    LINK_LIMIT = ENV["link_limit"] || 20
    CRAWL_LIMIT = ENV["crawl_limit"] || 2000
    crawled_at = DateTime.now

    Result.result.writer = ContactWriter

    Twitterer.not_crawled.limit(CRAWL_LIMIT).each do |tw|
      if tw.crawled_at.nil?
        ContactCrawler.crawl(tw.real_url, UrlCleaner.friendly(tw.real_url), nil, LINK_LIMIT, tw.fullname)
        tw.update_attributes(crawled_at: crawled_at)
      end
    end
  end

  task store: :environment do
    Rake::Task['twitter:store'].invoke
    Rake::Task['contact:store'].invoke
  end
end
