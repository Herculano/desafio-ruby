class PopulateProductsJob < ApplicationJob
  queue_as :default
  ROWS = 49
  def perform(store_id)
    store = Store.find(store_id)

    product_list = []
     (store.total_products/ROWS).ceil.times do |page|
      response = HTTParty.get("#{store.website}/api/catalog_system/pub/products/search",
                 :query => "_from=#{page*ROWS}&_to=#{(page+1)*ROWS}").parsed_response
      response.map do |r|
        product_list << {
          image: r["items"][0]["images"][0]["imageUrl"],
          external_link: r["link"],
          name: r["productName"],
          price: r["items"][0]["sellers"][0]["commertialOffer"]["Price"]
        }

       #TODO: Installments
      end
    end
    
    Product.create!(product_list) do |p|
      p.store = store
    end
  end
end
