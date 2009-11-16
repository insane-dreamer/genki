namespace :twitter do
  desc "Retrieve tweets"
  task :load_tweets => :environment do
    require 'twitter'
    httpauth = Twitter::HTTPAuth.new('account', 'password')
    client = Twitter::Base.new(httpauth)
    if Tweet.last
      last_tweet_id = Tweet.last.tweetid.to_i
      tweets = client.user_timeline(:since_id => last_tweet_id)
    else
      tweets = client.user_timeline(:count => 200)
    end
    # reverse order when adding to DB so that oldest tweet is added next rather than newest
    tweets.reverse.each { |t| 
          Tweet.create(:tweet => t.text, :tweetid => t.id.to_s, :created_at => t.created_at.to_datetime)
        }
  end
end
