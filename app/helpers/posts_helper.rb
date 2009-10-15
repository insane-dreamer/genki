module PostsHelper
  # This isn't strictly correct, but it's a pretty good guess
  # and saves another hit to the DB
  def more_content?
    @posts.size == Post::DEFAULT_LIMIT
  end

  def middle_nav_button
    if params[:action] == "index" 
      image = 'archives.gif'
      path = archives_path
    else
      image = 'win.gif'
      path = root_path
    end
    content_tag(:div, link_to(image_tag(image), path), :id => 'middleNavButton')
  end

end
