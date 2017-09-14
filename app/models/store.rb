class Store
  include Mongoid::Document
  field :name, type: String
  field :website, type: String
  field :logo, type: String
  field :email, type: String
  field :total_products, type: Integer

  has_many :products, dependent: :delete
  validates_presence_of :name, :website, :logo, :total_products

  after_save :load_api_products, if: -> {website_changed? || total_products_changed?}

  rails_admin do
    create do
      field :name
      field :email
      field :total_products
      field :logo
      field :website
    end
  end

  private
  
  def load_api_products
    products.delete_all
    PopulateProductsJob.perform_later(id.to_s)
  end
end
