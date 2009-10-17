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

  map.root :controller => 'frontpage', :action => 'index'
  map.resources :posts
  
  map.previous_post '/post/:id/previous', :controller => 'posts', :action => 'show_previous'
  map.next_post '/post/:id/next', :controller => 'posts', :action => 'show_next'
  map.previous_page '/page/:page/previous/:post', :controller => 'frontpage', :action => 'show_previous_page'
  map.next_page '/page/:page/next/:post', :controller => 'frontpage', :action => 'show_next_page'
  
  map.resources :sitemap

  map.resources :pages

  map.connect ':year/:month/:day/:slug/comments', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug/comments/new', :controller => 'comments', :action => 'new'
  map.connect ':year/:month/:day/:slug/comments.:format', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug', :controller => 'posts', :action => 'show', :requirements => { :year => /\d+/ }
  map.posts_with_tag ':tag', :controller => 'posts', :action => 'index'
  map.formatted_posts_with_tag ':tag.:format', :controller => 'posts', :action => 'index'
end
