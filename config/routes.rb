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

  # Registrations are skipped: signing up goes through Api::V1::UsersController#create.
  # Devise's own registrations#create calls sign_in, which raises
  # DisabledSessionError under config.api_only after already committing the record.
  devise_for :users, skip: [:registrations] # rubocop:disable Lint/Syntax
end
