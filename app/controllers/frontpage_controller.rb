class FrontpageController < ApplicationController

  def index
    @tag = params[:tag]
    @direction = params[:direction]
    if @direction
      page = @direction == "previous" ? params[:page].to_i - 1 : params[:page].to_i + 1
    else
      page = "last"
    end
    @section = params[:section] ? Section.find(params[:section].to_i) : Section.first
    @page, @posts = get_page_and_posts(@section,page)  
    @rssposts = Post.find_recent(:tag => @tag, :include => :tags)
    
    raise(ActiveRecord::RecordNotFound) if @tag && @posts.empty?
    
    respond_to do |format|
      format.html
      format.js
      format.atom
    end

  end
  
  def tweet  
    # only called with ajax, returns tweets.js.rjs
    tweets = Tweet.alltweets
    tweets.per_page = 6
    if params[:direction] == 'previous'
      @page = params[:page].to_i + 1
      @page = tweets.pages.count if @page > tweets.pages.count
    elsif params[:direction] == 'next'
      @page = params[:page].to_i - 1
      @page = 1 if @page <= 0
    else
      @page = 1
    end
    @tweets = tweets.pages.find(@page).tweets
    # previous == next because tweets are ordered in reverse
    @has_previous = true if tweets.pages.find(@page).next
    @has_next = true if tweets.pages.find(@page).previous
  end
  
  def search
    @query = params[:query]
    @results = Post.search @query, :page => params[:page], :per_page => 15
  end
  
	def submit
    if error = verify_submission(params)
      render :update do |page|
        page.replace_html :flash, content_tag(:div, error, :id => 'flash-message')
        page.visual_effect :highlight, "flash-message", {:duration => 1}
      end
    else
      Notifier.deliver_user_submission(params)
      render :partial => 'submit_notice'
    end
  end
  
  private

  def verify_submission(sub)
    email = Regexp.new(%r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i)
    case 
      when sub[:name].blank? || sub[:email].blank?
        @error = "Please include your name and email. Thanks!"
      when email.match(sub[:email].strip).nil?
        @error = "Invalid email address. Please check and resubmit."
    end
    return @error
  end

  def get_page_and_posts(section, pg)
    allposts = section.posts.scoped(:order => 'created_at ASC')
    allposts.per_page = section.per_page
    if pg == "last" or pg > allposts.pages.count
        page = allposts.pages.last
    elsif pg <= 0
        page = allposts.pages.first
    else
        page = allposts.pages.find(pg)
    end
    posts = page.posts
    return page, posts
  end

end
