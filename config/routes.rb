# frozen_string_literal: true

Rails.application.routes.draw do
  # Declarado antes do devise_for: com o subdominio 'api', estas rotas tem
  # precedencia sobre as rotas de registration do Devise (POST/PUT/DELETE /users).
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: %i[show create update destroy]
    end
  end

  # registrations e pulado: o cadastro passa por Api::V1::UsersController#create.
  # O registrations#create do Devise chama sign_in, que levanta
  # DisabledSessionError sob config.api_only depois de ja ter gravado o registro.
  devise_for :users, skip: [:registrations]
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
end
