# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Lint/Syntax
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  # Declared before devise_for so that POST /users on the "api" subdomain
  # reaches Api::V1::UsersController#create instead of Devise's registrations.
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: %i[show create update destroy]
    end
  end

  devise_for :users # rubocop:disable Lint/Syntax
end
