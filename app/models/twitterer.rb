class Twitterer < ActiveRecord::Base
  scope :not_crawled, -> { where(crawled_at: nil) }
end
