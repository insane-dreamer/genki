module FrontpageHelper

  def frontpage_navigation
    nav = ""
    nav << previous_page_button unless @posts.empty?
    nav << middle_archives_button(@section)
    nav << next_page_button unless @posts.empty?
  end

  def frontpage_tabs(section)
    nav = Section.all.map do |s|
      link_class = s == section ? 'carousel-jumper carousel-selected' : 'carousel-jumper'
      link_to_remote(s.name.upcase, :url => frontpage_path(:section => s), :html => {:class => link_class})
    end
    link_class = section == 'TWEET' ? 'carousel-jumper carousel-selected' : 'carousel-jumper'
    nav << link_to_remote("TWEET", :url => tweet_path(:page => 1), :html => {:class => link_class}) 
  end

  def previous_page_button
    arrow = !@posts.first.previous.empty? ? link_to_remote(image_tag('arrow_left.jpg', :class => 'arrow', :alt => 'Previous page'), :url => frontpage_path(:post => @posts.first, :section => @section, :direction => 'previous'), :html => {:class => 'ico-prev'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'leftArrow'
  end

  def next_page_button
    arrow = !@posts.last.next.empty? ? link_to_remote(image_tag('arrow_right.jpg', :class => 'arrow', :alt => 'Next page'), :url => frontpage_path(:post => @posts.last, :section => @section, :direction => 'next'), :html => {:class => 'ico-next'}) : "&nbsp;"
    content_tag :div, arrow, :id => 'rightArrow'
  end
  
  def section_div_id
    @section.per_page == 1 ? 'singlePostSummary' : 'twoPostSummary'
  end

end
