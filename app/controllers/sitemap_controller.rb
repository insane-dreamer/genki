class SitemapController < ApplicationController
  def index
    @posts = Post.find :all, :conditions => ["published_at < '#{Time.zone.now}'"]
    @pages = Page.find :all
    
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
end
