class FrontpageController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, :with => :bad_request

  def index
#    @tag = params[:tag]
    @section = if params[:section]
      # section could be name or id
      Section.find_by_name(params[:section].downcase) || Section.find(params[:section].to_i) 
    else
      Section.show_on_front.first
    end
    @posts = if params[:direction]
      Post.find(params[:post]).get_next(params[:direction],@section.per_page)
    else
      Post.latest(@section,@section.per_page)
    end
    # reverse posts so that latest one is on the right (placed last in the html)
    @posts.reverse!
    
#    raise(ActiveRecord::RecordNotFound) if @tag && @posts.empty?
    
    respond_to do |format|
      format.html { mark_last_visit }
      format.js
      format.atom
    end

  end
  
  def tweet
    # usually called with ajax
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
    respond_to do |format|
      format.js
      # this is in case anyone goes to /tweet manually
    	format.html
    end
            
  end
  
  def search
    @query = params[:query]
    @results = Post.pubbed.latest_first.search @query, :page => params[:page], :per_page => 15
    render :layout => 'application'
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
  
  def bad_request
    flash[:notice] = "That page does not exist!"
    redirect_to root_path
  end

  protected

  def verify_submission(sub)
    email = Regexp.new(%r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i)
    case 
      when sub[:name].blank? || sub[:email].blank? || sub[:homenum].blank? || sub[:country].blank?
        @error = "Please include your name, email, home # & country (email & home # for our info only)."
      when email.match(sub[:email].strip).nil?
        @error = "Invalid email address. Please check and resubmit."
    end
    return @error
  end

  def mark_last_visit
    @last_visit ||= cookies[:last_visit]
    cookies[:last_visit] = Time.now.utc
    @sections = Section.show_on_front
    total_new_posts = 0
    @sections.each { |s| total_new_posts += s.new_content_since(@last_visit) }
    if total_new_posts > 0
      flash[:notice] = "#{total_new_posts} new posts since your last visit!"
    end
    @new_tweets = Tweet.new_content_since(@last_visit)
  end

end
