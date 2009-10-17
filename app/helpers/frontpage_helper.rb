module FrontpageHelper

  def front_page_navigation(page,section)
    nav = previous_page_button(page,section)
    nav << middle_nav_button(section)
    nav << next_page_button(page,section)
  end

  def frontpage_tabs(section)
    Section.all.map do |s|
      link_class = s == section ? 'carousel-jumper carousel-selected' : 'carousel-jumper'
      link_to_remote(s.name.upcase, :url => root_path(:section => s), :html => {:class => link_class})
    end
  end

  def previous_page_button(page,section)
    arrow = page.previous ? link_to_remote(image_tag('arrow_left.jpg', :class => 'arrow'), :url => previous_page_path(:page => page, :section => section), :html => {:class => 'ico-prev'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'leftArrow'
  end

  def next_page_button(page,section)
    arrow = page.next ? link_to_remote(image_tag('arrow_right.jpg', :class => 'arrow'), :url => next_page_path(:page => page, :section => section), :html => {:class => 'ico-next'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'rightArrow'
  end

end
