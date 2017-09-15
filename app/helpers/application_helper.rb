module ApplicationHelper
  def store_logo
    Store.find_by(slug: params[:slug]).try(:logo) || false
  end
end
