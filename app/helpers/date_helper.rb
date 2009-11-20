module DateHelper
  def format_month(date)
    date.strftime("%B %Y")
  end
  
  def format_post_date(date)
    date.strftime("%B %d, %Y")
  end

  def format_comment_date(date)
    date.strftime("%d %b")
  end
end
