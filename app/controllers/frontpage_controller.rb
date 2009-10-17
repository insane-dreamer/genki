class FrontpageController < ApplicationController

  def index
    @tag = params[:tag]
    @section = params[:section] ||= Section.first
    @page, @posts = page_and_posts(@section)

    raise(ActiveRecord::RecordNotFound) if @tag && @posts.empty?

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show_next_page
     next_or_previous_page('next', params[:page], params[:section])
  end
  
  def show_previous_page
    next_or_previous_page('previous', params[:page], params[:section])
  end
  
  private
  
  def next_or_previous_page(direction, page, section)
    page = direction == "previous" ? page.to_i - 1 : page.to_i + 1
    @section = Section.find(section)
    @page, @posts = page_and_posts(@section, page)
    render :update do |page|
    	page.replace_html 'frontpage-posts', :partial => 'posts', :object => @posts
      page.replace_html 'arrows', front_page_navigation(@page,@section)
    end      
  end

  def page_and_posts(section, pg = "last")
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
