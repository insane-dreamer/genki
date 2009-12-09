class Admin::PostsController < Admin::BaseController
  before_filter :find_post, :only => [:show, :update, :destroy, :publish]
  before_filter :clear_cache, :only => [:create, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @unpublished = Post.unpublished.paginate(:page => params[:page])
        @published = Post.published.paginate(:page  => params[:page])
      }
    end
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Created post '#{@post.title}'"
          redirect_to(:action => 'show', :id => @post)
        }
      end
    else
      respond_to do |format|
        format.html { render :action => 'new', :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    if @post.update_attributes(params[:post])
      respond_to do |format|
        format.html {
          flash[:notice] = "Updated post '#{@post.title}'"
          redirect_to(:action => 'show', :id => @post)
        }
      end
    else
      respond_to do |format|
        format.html { render :action => 'show',        :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html {
        render :partial => 'post', :locals => {:post => @post} if request.xhr?
      }
    end
  end

  def new
    @post = Post.new
    render :action => 'show'
  end
  
  def preview
    @post = Post.build_for_preview(params[:post])

    respond_to do |format|
      format.js {
        render :partial => 'posts/post.html.erb'
      }
    end
  end

  def destroy
    undo_item = @post.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted post '#{@post.title}'"
        redirect_to :action => 'index' 
      end
      format.json { 
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :post         => @post
        }.to_json
      }
    end
  end

  def show_photo_link
    @photo = Upload.find(params[:id])
    render :update do |page|
      page.show 'photolinks'
    	page.replace_html 'photolinks', :partial => 'photolinks', :object => @photo
    end
  end

  def publish
    # publishes or unpublishes
    if @post.published
      success = 'un-published' if @post.update_attributes(:published => false)
    else         
      success = 'published' if @post.update_attributes(:published => true)
      Notifier.deliver_new_post(@post) unless @post.author_email.blank?
    end
    if success
      flash[:notice] = "Post #{@post.title} was #{success}."
    else
      flash[:error] = "Error occurred trying to publish/unpublish post."
    end
    redirect_to :action => index  
  end


  protected

  def find_post
    @post = Post.find(params[:id])
  end
  
  def clear_cache
    expire_page :controller => :posts, :action => :show
  end
  
end
