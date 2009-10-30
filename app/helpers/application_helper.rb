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

end
