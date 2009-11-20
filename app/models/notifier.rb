class Notifier < ActionMailer::Base
  
  def user_submission(submission)
    recipients "wtw@thefamily.org"
    from       submission[:email].strip
    subject    "WTW submission from: " + submission[:name]
    sent_on    Time.now
    body       submission
  end

  def new_comment(comment)
    @post = comment.post
    recipients comment.post.author_email
    from       "wtw@thefamily.org"
    subject    "New comment on your WTW post"
    sent_on    Time.now
    body       :comment => comment, :post => @post, :url => post_full_path_url(:year => @post.created_at.year.to_s, :month => @post.created_at.strftime("%m"), :day => @post.created_at.strftime("%d"), :slug => @post.slug, :host => "wtw.familymembers.com") + "#comments"
  end

end
