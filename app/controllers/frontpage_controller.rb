class FrontpageController < ApplicationController

  def index
    @tag = params[:tag]
    if params[:direction]
      page = params[:direction] == "previous" ? params[:page].to_i - 1 : params[:page].to_i + 1
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
    # note: Twitter "pages" work backwards. 1 is most recent, 2 prior to that, etc.
    @page = case params[:direction]
      when "previous" then params[:page].to_i + 1
      when "next" then params[:page].to_i - 1
      else 1
    end
    @section = TWEET_SECTION
    @tweets = Twitter::Search.new.from(TWEET_USER_ID).per_page(6).page(@page).fetch.results
    render :update do |page|
      page.replace_html 'frontpage-posts', :partial => 'tweets'
      page.replace_html 'arrows', :partial => 'tweet_nav'
      page.replace_html 'featureLeft', frontpage_tabs(@section)
    end
  end
  
  def search
    @query = params[:query]
    @results = Post.search @query, :page => params[:page], :per_page => 15
  end
  
	def submit
    Notifier.deliver_user_submission(params)
    flash[:notice] = "Thank you for your submission!" 
    redirect_to root_path
  end
				
  
  private

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
