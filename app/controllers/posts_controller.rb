class PostsController < ApplicationController

caches_page :show

  def show
    if params[:direction]
      # previous/next methods return an array
      @post = params[:direction] == "previous" ? Post.find(params[:id]).previous.first : Post.find(params[:id]).next.first
    else
      @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    end
    @comment = Comment.new
    respond_to do |wants|
      wants.html 
    	wants.js
    end
  end

end
