module FrontpageHelper

  def frontpage_navigation(page,section)
    nav = previous_page_button(page,section)
    nav << content_tag(:div, link_to(image_tag('archives.gif'), section_path(section)), :id => 'middleNavButton')
    nav << next_page_button(page,section)
  end

  def frontpage_tabs(section)
    Section.all.map do |s|
      link_class = s == section ? 'carousel-jumper carousel-selected' : 'carousel-jumper'
      link_to_remote(s.name.upcase, :url => frontpage_path(:section => s), :html => {:class => link_class})
    end
  end

  def previous_page_button(page,section)
    arrow = page.previous ? link_to_remote(image_tag('arrow_left.jpg', :class => 'arrow'), :url => change_page_path(:page => page, :section => section, :direction => 'previous'), :html => {:class => 'ico-prev'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'leftArrow'
  end

  def next_page_button(page,section)
    arrow = page.next ? link_to_remote(image_tag('arrow_right.jpg', :class => 'arrow'), :url => change_page_path(:page => page, :section => section, :direction => 'next'), :html => {:class => 'ico-next'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'rightArrow'
  end

  def section_div_id
    @section.per_page == 1 ? 'singlePostSummary' : 'twoPostSummary'
  end

end
