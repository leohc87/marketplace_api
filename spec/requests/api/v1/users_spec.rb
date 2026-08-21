# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  # The routes are namespaced under constraints: { subdomain: 'api' },
  # so every request has to carry the subdomain or it never reaches the controller.
  before(:each) { host! 'api.lvh.me' }

  let(:user_body_schema) do
    {
      type: :object,
      properties: {
        user: {
          type: :object,
          properties: {
            email: { type: :string, example: 'user@example.com' },
            password: { type: :string, example: '123456' },
            password_confirmation: { type: :string, example: '123456' }
          }
        }
      },
      required: %w[user]
    }
  end

  path '/users' do
    post('create user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: '123456' },
              password_confirmation: { type: :string, example: '123456' }
            },
            required: %w[email password password_confirmation]
          }
        },
        required: %w[user]
      }

      response(201, 'created') do
        let(:attributes) { FactoryBot.attributes_for(:user) }
        let(:user) { { user: attributes } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do
          user_response = JSON.parse(response.body, symbolize_names: true)
          expect(user_response[:email]).to eq attributes[:email]
          expect(User.find_by(email: attributes[:email])).to be_present
        end
      end

      response(422, 'unprocessable entity') do
        let(:user) { { user: { password: '123456', password_confirmation: '123456' } } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do
          user_response = JSON.parse(response.body, symbolize_names: true)
          expect(user_response[:errors][:email]).to include "can't be blank"
        end
      end
    end
  end

  path '/users/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show user') do
      tags 'Users'
      produces 'application/json'

      response(200, 'successful') do
        let(:existing_user) { FactoryBot.create(:user) }
        let(:id) { existing_user.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do
          user_response = JSON.parse(response.body, symbolize_names: true)
          expect(user_response[:email]).to eq existing_user.email
        end
      end

      response(404, 'not found') do
        let(:id) { 0 }
        run_test!
      end
    end

    patch('update user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: '123456' },
              password_confirmation: { type: :string, example: '123456' }
            }
          }
        },
        required: %w[user]
      }

      response(200, 'successful') do
        let(:existing_user) { FactoryBot.create(:user) }
        let(:id) { existing_user.id }
        let(:user) { { user: { email: 'updated@example.com' } } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do
          expect(existing_user.reload.email).to eq 'updated@example.com'
        end
      end

      response(422, 'unprocessable entity') do
        let(:existing_user) { FactoryBot.create(:user) }
        let(:id) { existing_user.id }
        let(:user) { { user: { email: 'bademail.com' } } }

        run_test! do
          user_response = JSON.parse(response.body, symbolize_names: true)
          expect(user_response[:errors][:email]).to include 'is invalid'
        end
      end
    end

    put('update user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: '123456' },
              password_confirmation: { type: :string, example: '123456' }
            }
          }
        },
        required: %w[user]
      }

      response(200, 'successful') do
        let(:existing_user) { FactoryBot.create(:user) }
        let(:id) { existing_user.id }
        let(:user) { { user: { email: 'replaced@example.com' } } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do
          expect(existing_user.reload.email).to eq 'replaced@example.com'
        end
      end
    end

    delete('delete user') do
      tags 'Users'

      response(204, 'no content') do
        let(:existing_user) { FactoryBot.create(:user) }
        let(:id) { existing_user.id }

        run_test! do
          expect(User.exists?(existing_user.id)).to be false
        end
      end

      response(404, 'not found') do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
