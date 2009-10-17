class PostsController < ApplicationController

  def show
    if params[:direction]
      @post = params[:direction] == "previous" ? Post.find(params[:id]).previous : Post.find(params[:id]).next
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
