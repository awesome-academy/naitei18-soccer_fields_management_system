module ApplicationHelper
  def full_title page_title
    base_title = t "footer.description"
    if page_title.blank?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
