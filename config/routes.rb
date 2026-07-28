# frozen_string_literal: true

Rails.application.routes.draw do
  # Declarado antes do devise_for: com o subdominio 'api', estas rotas tem
  # precedencia sobre as rotas de registration do Devise (POST/PUT/DELETE /users).
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: %i[show create update destroy]
    end
  end

  devise_for :users
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
end
