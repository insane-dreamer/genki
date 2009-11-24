class SectionsController < ApplicationController
  def index
  end

  def show
    @page = params[:page] ? params[:page].to_i : 1
    # the per_page corresponds to the number of months shown, not posts
    per_page = 2
    @section = Section.find(params[:id])
    @posts = @section.posts.published.find_all_grouped_by_month
    @months = @posts.paginate :page => @page, :per_page => per_page
    # use these vars for custom pagination
    # pages reversed since most recent is shown first
    @previous = @page + 1 if !@posts.paginate(:page => @page + 1, :per_page => per_page).empty?
    @next = @page - 1 if (!@posts.paginate(:page => @page - 1, :per_page => per_page).empty? if @page - 1 > 0)
  end

end
