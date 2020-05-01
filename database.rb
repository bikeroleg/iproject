# frozen_string_literal: true

require 'sequel'
require 'twitter'

# //
class Database

  DB = Sequel.connect('sqlite://tweets.db')

  def initialize
  end

  $client = Twitter::REST::Client.new do |config|
    config.consumer_key    = ''
    config.consumer_secret = ''
    config.access_token        = ''
    config.access_token_secret = ''
  end

  def table
    DB.create_table :tweets do
      primary_key :id
      Integer :twitter_id
      String :name
      String :tweet
      String :tweet_id
    end
  end

  $items = DB[:tweets]
  def insert(twitter_id, name, tweet, tweet_id)
    $items.insert(twitter_id: twitter_id, name: name, tweet: tweet, tweet_id: tweet_id)
  end

  def pull_all
    $items.all
  end

  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end

  def $client.get_all_tweets(user)
    collect_with_max_id do |max_id|
      options = {count: 100, include_rts: false}
      options[:max_id] = max_id unless max_id.nil?
      user_timeline(user, options)
    end
  end

  def fill(usernames)
    usernames.each do |x|
      ss = $client.get_all_tweets(x)
      ss.each { |q| insert(0, x, q.full_text, q.uri.to_s) }
    end
  end

  def count
    $items.count
  end

end
