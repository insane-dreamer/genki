module PostsHelper
  # This isn't strictly correct, but it's a pretty good guess
  # and saves another hit to the DB
  def more_content?
    @posts.size == Post::DEFAULT_LIMIT
  end

  def single_post_navigation(post)
    nav = previous_post_button(post)
    nav << middle_post_button(post)
    nav << next_post_button(post)
  end

  def previous_post_button(post)
    arrow = !post.previous.empty? ? link_to_remote(image_tag('arrow_left.jpg', :class => 'arrow'), :url => {:action => 'show', :id => post.id, :direction => 'previous'}, :html => {:class => 'ico-prev'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'leftArrow'
  end

  def next_post_button(post)
    arrow = !post.next.empty? ? link_to_remote(image_tag('arrow_right.jpg', :class => 'arrow'), :url => {:action => 'show', :id => post.id, :direction => 'next'}, :html => {:class => 'ico-next'}) : "&nbsp;"    
    content_tag :div, arrow, :id => 'rightArrow'
  end

  def middle_post_button(post)
    nav = content_tag(:div, link_to(image_tag('home.gif'), frontpage_path(:section => post.section)), :id => 'homeButton')
    nav << content_tag(:div, link_to(image_tag('archives_small.gif'), section_path(post.section)), :id => 'archivesButton')
    return nav
  end

end
