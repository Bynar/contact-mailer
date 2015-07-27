class CreateTwitterers < ActiveRecord::Migration
  def change
    create_table :twitterers do |t|
      t.integer :twitter_id
      t.string :username
      t.string :fullname, index:true
      t.datetime :last_tweet_date
      t.text :description
      t.string :location
      t.string :twitter_url
      t.integer :followers_count
      t.string :real_url, index:true

      t.timestamps null: false
    end
  end
end
