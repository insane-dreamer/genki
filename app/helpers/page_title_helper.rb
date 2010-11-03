module PageTitleHelper
  def posts_title(tag)
    compose_title((tag || "").to_s.titleize)
  end

  def post_title(post)
    compose_title(h(post.title))
  end

  def archives_title(section)
    compose_title(h(section.name.upcase) + " Archives")
  end

  def page_title(page)
    compose_title(h(page.title))
  end

  def frontpage_section_title(section)
    compose_title(h(section.name.upcase))
  end

  private

  def compose_title(*parts)
    (parts.unshift(config[:title])).reject(&:blank?).join(" - ") 
  end
end
