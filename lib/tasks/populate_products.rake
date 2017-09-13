namespace :populate_products do
  task :update => :environment do
    require 'httparty'
    queries = [{"_from" => "0", "_to" => "49"},
            {"_from" => "50", "_to" => "99"}]
    product_list = []
    queries.map do |q|
      response = HTTParty.get("http://www.timex.com.br/api/catalog_system/pub/products/search", :query => q).parsed_response
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
    puts product_list
    #Product.create!(product_list)
  end
end
