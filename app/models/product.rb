class Product
  include Mongoid::Document

  field :name, type: String
  field :price, type: String
  field :installments, type: Integer
  field :avatar, type: String
  field :external_link, type: String

  belongs_to :store
  validates_presence_of :website, :name, :logo_url, :email
end
