class Admin::SectionsController < Admin::BaseController

before_filter :find_section, :only => [:show, :update, :destroy]

  def index
    @sections = Section.paginate :order => "created_at DESC", :page  => params[:page]
  end

  def new
    @section = Section.new
    render :action => :show
  end

  def show
  end

  def create  
    if Section.create(params[:section])
      flash[:notice] = "Section created."
      redirect_to :action => :index
    else
      redirect_to :action => :new
    end
  end

  def edit
    render :action => :show
  end

  def update
    if @section.update_attributes(params[:section])
      flash[:notice] = "Section updated."
      redirect_to :action => :index
    else
      redirect_to :action => :edit, :id => params[:id]
    end
  end

  def destroy
    if @section.destroy
      flash[:notice] = "Section deleted."
      redirect_to :action => :index
    end    
  end

  protected 

  def find_section
    @section = Section.find(params[:id])
  end


end
