namespace :twitter do
  desc "Retrieve tweets"
  task :load_tweets => :environment do
    require 'twitter'
    # initialize these variables in initializers/*.rb
    httpauth = Twitter::HTTPAuth.new(TWITTER_USER, TWITTER_PASSWORD)
    client = Twitter::Base.new(httpauth)
    if Tweet.last
      last_tweet_id = Tweet.last.tweetid.to_i
      tweets = client.user_timeline(:since_id => last_tweet_id)
    else
      tweets = client.user_timeline(:count => 200)
    end
    @url = /(http:\/\/\w*\.[\w\/]*)/
    # reverse order when adding to DB so that oldest tweet is added next rather than newest
    tweets.reverse.each { |t| 
          # match URLs and make into links
          text = t.text.gsub(@url,"<a href=\"\\0\">\\0</a>")
          Tweet.create(:tweet => text, :tweetid => t.id.to_s, :created_at => t.created_at.to_datetime)
        }
  end
end
