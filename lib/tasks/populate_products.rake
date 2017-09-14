namespace :populate_products do
  task :update => :environment do
    require 'httparty'
    ROWS = 49
    store = Store.find("59b9a5753b413207bdba6fcd")

    product_list = []
     (store.total_products/ROWS).ceil.times do |page|

      response = HTTParty.get("#{store.website}/api/catalog_system/pub/products/search",
                 :query => "_from=#{page*ROWS}&_to=#{(page+1)*ROWS}").parsed_response

      response.map do |r|
        product_list << {
          avatar: r["items"][0]["images"][0]["imageUrl"],
          external_link: r["link"],
          name: r["productName"],
          installments: r["items"][0]["sellers"][0]["commertialOffer"]["Installments"].map { |c| c["NumberOfInstallments"] }.max,
          price: r["items"][0]["sellers"][0]["commertialOffer"]["Price"],
          store_id: store.id
        }
      end
    end
    Product.collection.insert_many(product_list)
  end
end
