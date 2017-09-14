class ProductController < ApplicationController
  before_action :get_store

  def index
    @products = Product.search(
                  set_search_value,
                  fields: [:name, :store_id],
                  page: params[:page] || 1,
                  per_page: 20,
                  where: {store_id: [get_store]}
                )
  end

  private

  def get_store
    Store.find_by(slug: params[:slug])
  end
  def set_search_value
    params[:s].present? ? params[:s] : "*"
  end
end
