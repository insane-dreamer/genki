module PostsHelper
  # This isn't strictly correct, but it's a pretty good guess
  # and saves another hit to the DB
  def more_content?
    @posts.size == Post::DEFAULT_LIMIT
  end

  def single_post_navigation
    navigation = previous_nav_button
    navigation << middle_nav_button
    navigation << next_nav_button
  end

  def previous_nav_button
    arrow = @post.previous ? link_to_remote(image_tag('arrow_left.jpg', :class => 'arrow'), :url => previous_post_path(@post), :html => {:class => 'ico-prev'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'leftArrow'
  end

  def next_nav_button
    arrow = @post.next ? link_to_remote(image_tag('arrow_right.jpg', :class => 'arrow'), :url => next_post_path(@post), :html => {:class => 'ico-next'}) : "&nbsp;"    
    content_tag :div, arrow, :id => 'rightArrow'
  end

  def middle_nav_button
    if params[:action] == "index" 
      image = 'archives.gif'
      path = archives_path
    else
      image = @post.section.name + '.gif'
      path = root_path
    end
    content_tag(:div, link_to(image_tag(image), path), :id => 'middleNavButton')
  end

end
