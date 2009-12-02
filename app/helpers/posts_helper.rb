module PostsHelper
  # This isn't strictly correct, but it's a pretty good guess
  # and saves another hit to the DB
  def more_content?
    @posts.size == Post::DEFAULT_LIMIT
  end

  def single_post_navigation(post)
    nav = previous_post_button
    nav << middle_home_button(post.section_id,false)
    nav << middle_archives_button(post.section_id,false)
    nav << next_post_button
  end

  def previous_post_button
    arrow = @previous ? link_to(image_tag('arrow_left.jpg', :class => 'arrow', :alt => 'Previous page'), post_path(@previous), :html => {:class => 'ico-prev'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'leftArrow'
  end

  def next_post_button
    arrow = @next ? link_to(image_tag('arrow_right.jpg', :class => 'arrow', :alt => 'Next page'), post_path(@next), :html => {:class => 'ico-next'}) : "&nbsp;"    
    content_tag :div, arrow, :id => 'rightArrow'
  end

end
