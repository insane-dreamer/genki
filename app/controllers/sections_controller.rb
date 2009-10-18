class SectionsController < ApplicationController
  def index
  end

  def show
    @section = Section.find(params[:id])
    @months = @section.posts.find_all_grouped_by_month
  end

end
