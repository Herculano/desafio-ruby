task :populate_products => :environment do
  puts "Initializing"
  store = Store.find("59bb28a9b931ed007195f291")
  product_list = []
   (store.total_products/ROWS).ceil.times do |page|
    response = HTTParty.get("#{website_handling(store)}/api/catalog_system/pub/products/search",
               :query => "_from=#{page*ROWS}&_to=#{(page+1)*ROWS}").parsed_response
    puts reponse
    response.map do |r|
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
  puts "done."
end
