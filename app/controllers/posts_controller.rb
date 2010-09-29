class PostsController < ApplicationController

# caches_page :show

  def show
    if params[:direction]
      # previous/next methods return an array
      @post = params[:direction] == "previous" ? Post.published.find(params[:id]).previous.first : Post.published.find(params[:id]).next.first
    else
      @post = Post.published.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    end
    @comment = Comment.new
    @previous = @post.previous.empty? ? nil : @post.previous.first
    @next = @post.next.empty? ? nil : @post.next.first
    respond_to do |wants|
      wants.html 
    	wants.js
    	wants.atom { render :nothing => true }
    end
  end

end
