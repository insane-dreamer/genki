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
    recipients [comment.post.author_email, "wtw@thefamily.org"]
    from       "wtw@thefamily.org"
    subject    "New comment on your WTW post"
    sent_on    Time.now
    body       :comment => comment, :post => @post, :url => gen_post_url(@post) + "#comments"
  end

  def new_post(post)
    recipients post.author_email
    from       "wtw@thefamily.org"
    subject    "New WTW article from you!"
    sent_on    Time.now
    body       :post => post, :url => gen_post_url(post)
  end

protected

  def gen_post_url(post)
      post_full_path_url(:year => post.updated_at.year.to_s, :month => post.updated_at.strftime("%m"), :day => post.updated_at.strftime("%d"), :slug => post.slug, :host => "wtw.familymembers.com")  
  end
  
end
