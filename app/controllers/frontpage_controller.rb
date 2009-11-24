class FrontpageController < ApplicationController

  def index
    @tag = params[:tag]
    @section = params[:section] ? Section.find(params[:section].to_i) : Section.first
    if params[:direction]
      lastpost = Post.published.find(params[:post])
      @posts = params[:direction] == "previous" ? lastpost.previous(@section.per_page) : lastpost.next(@section.per_page)
    else
      @posts = Post.latest(@section,@section.per_page)
    end
    # reverse posts so that latest one is on the right (placed last in the html)
    @posts.reverse!
    @rssposts = Post.published.find_recent(:tag => @tag, :include => :tags)
    
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
    tweets.per_page = 7
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
    @results = Post.pubbed.latest_first.search @query, :page => params[:page], :per_page => 15
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

end
