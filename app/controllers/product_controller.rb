class ProductController < ApplicationController
  before_action :get_store

  def index
    @products = Product.where(store_id: get_store).page(params[:page])
  end

  private

  def get_store
    Store.find_by(slug: params[:slug])
  end
end
