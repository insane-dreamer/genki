class FrontpageController < ApplicationController

  def index
    @tag = params[:tag]
    @section = params[:section] ? Section.find(params[:section].to_i) : Section.first
    @page, @posts = get_page_and_posts(@section)  
    raise(ActiveRecord::RecordNotFound) if @tag && @posts.empty?
    respond_to do |format|
      format.html
      format.js
      format.atom { render :layout => false }
    end
  end

  def change_page
    page = params[:direction] == "previous" ? params[:page].to_i - 1 : params[:page].to_i + 1
    @section = Section.find(params[:section])
    @page, @posts = get_page_and_posts(@section, page)
    render :template => 'frontpage/index.js.rjs'
  end
  
  private

  def get_page_and_posts(section, pg = "last")
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
