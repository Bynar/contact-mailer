class Twitterer < ActiveRecord::Base
  scope :not_crawled, -> { where(crawled_at: nil) }

  def self.outstanding
    self.not_crawled.count
  end
end
