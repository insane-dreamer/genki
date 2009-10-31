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
  
  def search
    @query = params[:query]
    @results = Post.search @query, :page => params[:page], :per_page => 15
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
