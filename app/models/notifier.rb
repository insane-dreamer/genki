class Notifier < ActionMailer::Base
  
  def user_submission(submission)
    recipients "wtw@thefamily.org"
    from       "WTW site submissions <wtw@wsfamily.com>" 
    subject    "Submission from: " + submission[:name]
    sent_on    Time.now
    body       submission
  end

end
