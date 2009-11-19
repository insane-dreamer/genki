class Notifier < ActionMailer::Base
  
  def user_submission(submission)
    recipients "wtw@thefamily.org"
    from       submission[:email] 
    subject    "WTW submission from: " + submission[:name]
    sent_on    Time.now
    body       submission
  end

end
