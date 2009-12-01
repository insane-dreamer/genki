ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resource :session

    admin.resource :dashboard, :controller => 'dashboard'

    admin.resources :posts, :new => {:preview => :post}
    admin.resources :pages, :new => {:preview => :post}
    admin.resources :uploads
    admin.resources :comments, :member => {:mark_as_spam => :put, :mark_as_ham => :put}
    admin.resources :tags
    admin.resources :undo_items, :member => {:undo => :post}
    admin.resources :sections
  end

  map.admin_health '/admin/health/:action', :controller => 'admin/health', :action => 'index'
  map.photolink '/upload/:id/link', :controller => 'admin/posts', :action => 'show_photo_link'

  map.connect '/admin', :controller => 'admin/dashboard', :action => 'show'
  map.connect '/admin/api', :controller => 'admin/api', :action => 'index'

  map.resources :posts
  map.resources :sections, :path_prefix => 'archives', :only => [:show]
  map.resources :sitemap
  map.resources :pages 

  # frontpage routes
  map.frontpage '/section/:section', :controller => 'frontpage', :action => 'index'
  map.search '/search', :controller => 'frontpage', :action => 'search' 
  map.submit '/submit', :controller => 'frontpage', :action => 'submit'
  map.tweet '/tweet/:page/:direction', :controller => 'frontpage', :action => 'tweet', :defaults => { :direction => 'none', :page => 1 }
  map.about '/about', :controller => 'pages', :action => 'show', :id => 'about'

  map.connect '/tweet', :controller => 'frontpage', :action => 'tweet'

  map.rss '/feed.:format', :controller => 'frontpage', :action => 'index'

  map.connect ':section', :controller => 'frontpage', :action => 'index'

  map.root :frontpage 
  
  map.post_full_path ':year/:month/:day/:slug', :controller => 'posts', :action => 'show', :requirements => { :year => /\d+/ }
  map.connect ':year/:month/:day/:slug/comments', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug/comments/new', :controller => 'comments', :action => 'new'
  map.connect ':year/:month/:day/:slug/comments.:format', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug', :controller => 'posts', :action => 'show', :requirements => { :year => /\d+/ }
  # no support for tags at present
  # map.posts_with_tag '/archives/:tag', :controller => 'sections', :action => 'index'


end
