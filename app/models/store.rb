class Store
  include Mongoid::Document
  field :name, type: String
  field :website, type: String
  field :logo, type: String
  field :email, type: String
  field :total_products, type: Integer
  field :slug, type: String
  field :homestore, type: Boolean, default: false

  index({slug: 1}, {unique: true})

  has_many :products, dependent: :delete

  validates_presence_of :name, :website, :logo, :total_products
  validates_uniqueness_of :slug
  validates_uniqueness_of :homestore, if: :homestore?

  accepts_nested_attributes_for :products

  before_save :set_slug, if: -> { name_changed? || self.slug.blank? }
  after_save :load_api_products, if: -> { website_changed? || total_products_changed? }

  rails_admin do
    list do
      field :logo do
        pretty_value do
          bindings[:view].tag(:img, {:src => bindings[:object].logo, style: "width: 100px"})
        end
      end
      field :name
      field :email
      field :website
      field :total_products
      field :homestore
    end
    create do
      field :name
      field :email
      field :total_products
      field :logo
      field :website
      field :homestore
    end
  end

  private

  def load_api_products
    products.delete_all
    PopulateProductsJob.perform_later(id.to_s)
  end
  def set_slug
    self.slug = I18n.transliterate(name).underscore.dasherize
  end
end
