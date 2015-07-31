class AddCrawledAtToTwitterers < ActiveRecord::Migration
  def change
    add_column :twitterers, :crawled_at, :timestamp
  end
end
