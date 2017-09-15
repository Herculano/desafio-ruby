class PopulateProductsJob < ApplicationJob
  require 'httparty'
  queue_as :default
  ROWS = 49
  def perform(store_id)
    store = Store.find(store_id)
    product_list = []
     (store.total_products/ROWS).ceil.times do |page|
      response = HTTParty.get("#{website_handling(store)}/api/catalog_system/pub/products/search",
                 :query => "_from=#{page*ROWS}&_to=#{(page+1)*ROWS}").parsed_response
      response.each do |r|
        product_list << {
          store_id: store.id,
          avatar: r["items"][0]["images"][0]["imageUrl"],
          external_link: r["link"],
          name: r["productName"],
          installments: r["items"][0]["sellers"][0]["commertialOffer"]["Installments"].map { |c| c["NumberOfInstallments"] }.max,
          price: r["items"][0]["sellers"][0]["commertialOffer"]["Price"]
        }
      end
    end
    Product.collection.insert_many(product_list)
    Product.reindex
  end

  private

  def website_handling(store)
    _w  = store.website
    _w.last == "/" ? _w[0..-2] : _w
  end
end
