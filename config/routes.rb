 require 'sidekiq/web'
Rails.application.routes.draw do
  root to: 'page#index'
  get '/lojas', to: 'store#index', as: :store
  get '/loja/:slug', to: 'product#index', as: :product

  devise_for :users

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'
end
