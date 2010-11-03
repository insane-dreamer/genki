class Tweet < ActiveRecord::Base

named_scope :alltweets, :order => "created_at DESC"

def self.new_content_since(last_visit)
  if last_visit
    return true if Tweet.count(:conditions => ["created_at > ?", last_visit.to_time]) > 0
  end
end

end