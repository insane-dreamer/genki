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

  map.connect '/admin', :controller => 'admin/dashboard', :action => 'show'
  map.connect '/admin/api', :controller => 'admin/api', :action => 'index'
  map.archives '/archives', :controller => 'archives', :action => 'index'

  map.connect 'post/:id/:direction', :controller => 'posts', :action => 'show'

  map.resources :posts
  map.resources :sections

  map.root :controller => 'frontpage', :action => 'index'
  
  map.frontpage '/home/section/:section', :controller => 'frontpage', :action => 'index'
  map.change_page '/home/section/:section/page/:page/:direction', :controller => 'frontpage', :action => 'index'
  map.switch_tab '/home/tab/:section', :controller => 'frontpage', :action => 'switch_tab'
  
  map.resources :sitemap
  map.resources :frontpage
  map.resources :pages

  map.connect ':year/:month/:day/:slug/comments', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug/comments/new', :controller => 'comments', :action => 'new'
  map.connect ':year/:month/:day/:slug/comments.:format', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug', :controller => 'posts', :action => 'show', :requirements => { :year => /\d+/ }
  map.posts_with_tag ':tag', :controller => 'posts', :action => 'index'
  map.formatted_posts_with_tag ':tag.:format', :controller => 'posts', :action => 'index'
end
