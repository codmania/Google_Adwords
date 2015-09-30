module ApplicationHelper
  def nav_active(path)
    'active' if current_page?(path)
  end
end
