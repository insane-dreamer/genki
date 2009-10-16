class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @posts = Post.find_recent(:tag => @tag, :include => :tags).paginate(:page => params[:page], :per_page => 1)

    raise(ActiveRecord::RecordNotFound) if @tag && @posts.empty?

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    @comment = Comment.new
  end

  def show_previous
    show_next_or_previous("previous", params[:id])
  end

  def show_next
    show_next_or_previous("next", params[:id])
  end

  private 
  
  def show_next_or_previous(direction,id)
    @post = direction == "previous" ? Post.find(id).previous : Post.find(id).next
    render :update do |page|
    	page.replace_html 'fullPost', :partial => 'post', :object => @post
      page.replace_html 'arrows', single_post_navigation
    end  
  end

end
