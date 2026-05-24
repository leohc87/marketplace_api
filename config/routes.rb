# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  constraints subdomain: 'api' do
    namespace :api, defaults: { format: :json }, path: '/' do
      scope module: :v1 do
        # suas rotas aqui
      end
    end
  end
end
