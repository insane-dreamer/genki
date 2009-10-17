module PostsHelper
  # This isn't strictly correct, but it's a pretty good guess
  # and saves another hit to the DB
  def more_content?
    @posts.size == Post::DEFAULT_LIMIT
  end

  def single_post_navigation(post)
    nav = previous_post_button(post)
    nav << middle_nav_button(post.section)
    nav << next_post_button(post)
  end

  def previous_post_button(post)
    arrow = post.previous ? link_to_remote(image_tag('arrow_left.jpg', :class => 'arrow'), :url => previous_post_path(post), :html => {:class => 'ico-prev'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'leftArrow'
  end

  def next_post_button(post)
    arrow = post.next ? link_to_remote(image_tag('arrow_right.jpg', :class => 'arrow'), :url => next_post_path(post), :html => {:class => 'ico-next'}) : "&nbsp;"    
    content_tag :div, arrow, :id => 'rightArrow'
  end

end
