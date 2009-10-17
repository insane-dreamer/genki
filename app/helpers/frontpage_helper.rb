module FrontpageHelper

  def front_page_navigation(page,post)
    nav = previous_page_button(page,post)
    nav << middle_nav_button(post)
    nav << next_page_button(page,post)
  end

  def previous_page_button(page,post)
    arrow = page.previous ? link_to_remote(image_tag('arrow_left.jpg', :class => 'arrow'), :url => previous_page_path(:page => page, :post => post), :html => {:class => 'ico-prev'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'leftArrow'
  end

  def next_page_button(page,post)
    arrow = page.next ? link_to_remote(image_tag('arrow_right.jpg', :class => 'arrow'), :url => next_page_path(:page => page, :post => post), :html => {:class => 'ico-next'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'rightArrow'
  end


end
