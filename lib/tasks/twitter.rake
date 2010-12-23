namespace :twitter do
  desc "Retrieve tweets"
  task :load_tweets => :environment do
    require 'twitter'
    if Tweet.last
      last_tweet_date = Tweet.last.created_at.strftime("%Y-%m-%d")
      tweets = Twitter::Search.new.since(last_tweet_date).from(TWITTER_USER).fetch
    else
      tweets = Twitter::Search.new.from(TWITTER_USER).fetch
    end
    puts "#{tweets.length} Tweets (incl. duplicates) found"
    # get rid of any tweets that are already in the DB; only compare those from the same day
    tweets.reject! { |t| t.created_at.to_date == Tweet.last.created_at.to_date && Tweet.find_by_tweetid(t.id.to_s) }
    puts "#{tweets.length} new Tweets found"
    @url = /(http:\/\/\w*\.[\w\/\.-]*)/
    # reverse order when adding to DB so that oldest tweet is added next rather than newest
    tweets.reverse.each { |t| 
          # match URLs and make into links
          Tweet.create(:tweet => t.text, :tweetid => t.id.to_s, :created_at => t.created_at.to_datetime)
          Tweet.last.update_attribute(:tweet, t.text.gsub(@url,"<a href=\"\\0\">\\0</a>"))
          puts Tweet.last.tweet
          puts
        }
  end
end
