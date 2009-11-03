class Tweet < ActiveRecord::Base

named_scope :alltweets, :order => "created_at DESC"

end