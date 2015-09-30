class Twitterer < ActiveRecord::Base
  scope :processing, -> { where(crawled_at: nil) }

  def self.outstanding
    self.not_crawled.count
  end
end
