TWEET_USER_ID = 'familyintl'
httpauth = Twitter::HTTPAuth.new(TWEET_USER_ID, 'activatetheworld')
TWEET_CLIENT = Twitter::Base.new(httpauth)
TWEET_SECTION = Section.find_by_name('tweet')
