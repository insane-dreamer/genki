class Notifier < ActionMailer::Base
  
  def user_submission(submission)
    recipients "francis@ws.local"
    from       "WTW site submissions <wtw@thefamily.org>" 
    subject    "Submission from: " + submission[:name]
    sent_on    Time.now
    body       submission
  end

end
