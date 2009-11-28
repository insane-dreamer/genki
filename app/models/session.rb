class Session < ActiveRecord::Base

  # get rid of expired or old sessions to defeat session fixation
  def self.sweep(time_ago = nil)
      when /^(\d+)m$/ 
        Time.now - $1.to_i.minute 
      when /^(\d+)h$/ 
        Time.now - $1.to_i.hour 
      when /^(\d+)d$/ 
        Time.now - $1.to_i.day 
      else Time.now - 1.hour
    delete_all ["updated_at < ? OR created_at < ?", time, 1.day.ago]
  end

end