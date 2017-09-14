 require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'
end
