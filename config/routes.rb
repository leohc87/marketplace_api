# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  constraints subdomain: 'api' do
    namespace :api, defaults: { format: :json }, path: '/' do
      scope module: :v1,
            constraints: ApiConstraints.new(version: 1, default: true) do
        resources :users, only: %i[index show create]
      end
    end
  end
end
