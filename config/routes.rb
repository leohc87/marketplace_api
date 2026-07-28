# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Lint/Syntax
  devise_for :users
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: %i[show create update]
    end
  end # rubocop:disable Lint/Syntax
end
