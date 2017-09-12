class Product
  include Mongoid::Document

  field :name, type: String
  field :price, type: String
  field :plots, type: Integer
  field :avatar, type: String
  field :external_link, type: String

end
