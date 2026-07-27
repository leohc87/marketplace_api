# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) do
    request.headers['Accept'] = 'application/vnd.marketplace.v1'
  end

  describe 'GET /show' do
    before(:each) do
      @user = FactoryBot.create(:user)
      get :show, params: { id: @user.id }, format: :json
    end
    it 'returns the information about a report on a hash' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eq @user.email
    end

    it { should respond_with :ok }
  end

  describe 'POST #create' do
    context 'when the user is successfully created' do
      before(:each) do
        @user_attributes = FactoryBot.attributes_for(:user)
        post :create, params: { user: @user_attributes }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_user_attributes = {
          password: '12345678',
          password_confirmation: '12345678'
        }
        post :create, params: { user: @invalid_user_attributes }, format: :json
      end

      it 'renders an errors json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is successfully updated' do
      before(:each) do
        @user = FactoryBot.create(:user)
        patch :update, params: { id: @user.id, user: { email: 'newemail@example.com' } }, format: :json
      end

      it 'updates the user email' do
        @user.reload
        expect(@user.email).to eq 'newemail@example.com'
      end

      it 'renders the json representation for the updated user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq 'newemail@example.com'
      end

      it { should respond_with :ok }
    end

    context 'when is not updated' do
      before(:each) do
        @user = FactoryBot.create(:user) # criando novo registro no banco de dados para teste
        patch :update, params: { id: @user.id, user: { email: 'bademail.com' } }, format: :json # fazendo req via patch
      end

      it 'renders an errors json' do # entra aqui pra executar o teste, e espera que retorne um json com a chave errors
        user_response = JSON.parse(response.body, symbolize_names: true) # response.body é o corpo da resposta da requisição, que é um json, e o parse transforma em hash
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be updated' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include 'is invalid'
      end

      it { should respond_with :unprocessable_entity }
    end
  end
end
