class Twitterer < ActiveRecord::Base
  scope :not_crawled, -> { where(crawled_at: nil) }
  scope :by_crawled_dates, -> { group("CAST(crawled_at as DATE)").order("CAST(crawled_at as DATE)") }
  scope :by_created_dates, -> { group("CAST(created_at as DATE)").order("CAST(created_at as DATE)") }

  def self.outstanding
    self.not_crawled.count
  end

  def self.crawled
    self.by_crawled_dates.count
  end

  def self.processing
    self.not_crawled.by_created_dates.count
  end
end
