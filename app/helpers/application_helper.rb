# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def author
    Struct.new(:name, :email).new(config[:author][:name], config[:author][:email])
  end

  def open_id_delegation_link_tags(server, delegate)
    links = <<-EOS
      <link rel="openid.server" href="#{server}" />
      <link rel="openid.delegate" href="#{delegate}" />
    EOS
  end
  
  def format_comment_error(error)
    {
      'body'   => 'Please comment',
      'author' => 'Please provide your name or OpenID identity URL',
      'base'   => error.last
    }[error.first]
  end

  def number_comments(post)
    if post.approved_comments.size > 0 
      "(#{ link_to(pluralize(post.approved_comments.size, "comment"), post_path(post, :anchor => 'comments')) })"
    end
  end
  
  def host_url
    request.protocol + request.host
  end

  def upload_thumbnail(upload)
    if upload.is_image?
      image_tag(upload.file.url, :class => 'upload_thumbnail')
    else
      content_tag(:div, "&nbsp;", {:class => 'upload_thumbnail'})
    end
  end

  def show_flash(options={})
    options = {:fade => 1, :display => 2, :highlight => 3}.merge(options)
    html = content_tag(:div, flash.collect{ |key,msg| content_tag(:div, msg, :class => key, :attributes => "style = display: none;") }, :id => 'flash-message')
    html << content_tag(:script, "new Effect.Highlight('flash-message', {duration: #{options[:highlight]}});") if options[:highlight]
    html << content_tag(:script, "setTimeout(\"$('flash-message').fade({duration: #{options[:fade]}});\", #{options[:display]*1000}); return false;")
  end

  def search_and_submit_links
    html = link_to_function('CONTRIBUTE', nil, :style => "background:none;") do |page| 
      page.visual_effect(:blind_up, 'search', { :duration => 0.5 })
      page.visual_effect(:toggle_blind, 'submit', { :duration => 0.5 }) 
      end 
    html << link_to_function('SEARCH') do |page| 
      page.visual_effect(:blind_up, 'submit', { :duration => 0.5 })
      page.visual_effect(:toggle_blind, 'search', { :duration => 0.5 }) 
      end 
  end

  def middle_home_button(section=Section.first,centered=true)
    if centered 
      content_tag(:div, link_to(image_tag('home.gif'), frontpage_path(:section => section)), :id => 'homeButton', :class => 'centered_button')
    else    
      content_tag(:div, link_to(image_tag('home.gif'), frontpage_path(:section => section)), :id => 'homeButton')
    end
  end

end
