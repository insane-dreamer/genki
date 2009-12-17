class SectionsController < ApplicationController
  def index
  end

  def show
    @page = params[:page] ? params[:page].to_i : 1
    # the per_page corresponds to the number of months shown, not posts
    per_page = 2
    # params[:id] could be the id or the section name (for nice URLs)
    @section = params[:id].to_i > 0 ? Section.find(params[:id]) : Section.find_by_name(params[:id].gsub('-',' '))
    posts = @section.posts.published.find_all_grouped_by_month
    @months = posts.paginate :page => @page, :per_page => per_page
    # use these vars for custom pagination
    # pages reversed since most recent is shown first
    @previous = @page + 1 if !posts.paginate(:page => @page + 1, :per_page => per_page).empty?
    @next = @page - 1 if (!posts.paginate(:page => @page - 1, :per_page => per_page).empty? if @page - 1 > 0)
  end

end
