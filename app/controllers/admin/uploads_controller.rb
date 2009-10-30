class Admin::UploadsController < Admin::BaseController
  before_filter :find_upload, :only => [:show, :update, :destroy]
  
  def index
    respond_to do |format|
      format.html { @uploads = Upload.paginate :order => "created_at DESC", :page  => params[:page] }
      format.xml { render :xml => Upload.find(:all) }
    end
  end

  def show
    respond_to do |format|
      format.html { render :partial => 'upload', :locals => { :upload => @upload } if request.xhr? }
    end
  end

  def new
    @upload = Upload.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @upload }
    end
  end

  def create
    @upload = Upload.new(params[:upload])

    respond_to do |format|
      if @upload.save
        flash[:notice] = 'Upload was successfully created.'
        format.html { redirect_to(:action => 'index') }
        format.xml  { render :xml => @upload, :status => :created, :location => @upload }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @upload.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @upload = Upload.find(params[:id])

    respond_to do |format|
      if @upload.update_attributes(params[:upload])
        flash[:notice] = 'Upload was successfully updated.'
        format.html { redirect_to(:action => 'show', :id => @upload) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @upload.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to(admin_uploads_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def find_upload
    @upload = Upload.find(params[:id])
  end
end
