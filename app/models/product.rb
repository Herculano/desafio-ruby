class Product
  include Mongoid::Document

  field :name, type: String
  field :price, type: String
  field :installments, type: Integer
  field :avatar, type: String
  field :external_link, type: String
  field :reindex, type: Boolean

  belongs_to :store
  validates_presence_of :name, :external_link, :avatar

  after_create :products_reindex, if: :reindex
  after_update :reindex_products, if: :name_changed?

  accepts_nested_attributes_for :store

  searchkick
  def search_data
    {
      name:     name,
      store_id: store.id.to_s
    }
  end

  rails_admin do
    list do
      field :avatar do
        pretty_value do
          bindings[:view].tag(:img, { :src => bindings[:object].avatar, style: 'width:100px' })
        end
      end
      field :name
      field :price
      field :installments
      field :store
    end
    create do
      field :name
      field :avatar
      field :price
      field :installments
      field :store
      field :reindex, :hidden do
        default_value { true }
      end
    end
  end

  private

  def products_reindex
    self.class.reindex
  end
end
