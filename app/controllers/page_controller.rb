class PageController < ApplicationController
  def index
    store = Store.where(homestore: true).first
    if store
      redirect_to product_path(store.slug)
    else
      redirect_to store_path
    end
  end
end
