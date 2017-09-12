namespace :populate_products do
  task :update => :environment do
    require 'httparty'
    queries = [{"_from" => "0", "_to" => "49"},
            {"_from" => "50", "_to" => "99"}]
    queries.each do |q|
      response = HTTParty.get("http://www.timex.com.br/api/catalog_system/pub/products/search", :query => q).parsed_response
      product_list = response.map do |r|
        {id: r["productId"], external_link: r["link"], name: r["productName"]}
      end

    end
    puts product_list
    #Product.create!(product_list)
  end
end
