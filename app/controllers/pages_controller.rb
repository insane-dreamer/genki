class PagesController < ApplicationController
  def show
    # the id (slug) could be a string or an array
    # depending on whether it has / in the slug name to give the appearance of a hierarchal structure
    # converting the string to an array and joining will have no effect on it
    @page = Page.find_by_slug(params[:id].to_a.join('/')) 
    unless @page
      flash[:notice] = "That page does not exist!"
      redirect_to root_path
    end
  end
end
