class Product
  include Mongoid::Document

  field :name, type: String
  field :price, type: String
  field :installments, type: Integer
  field :avatar, type: String
  field :external_link, type: String

  belongs_to :store
  validates_presence_of :name, :external_link, :avatar

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
  end
end
