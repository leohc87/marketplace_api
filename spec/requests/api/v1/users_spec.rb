# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /show' do
    before(:each) do
      @user = FactoryBot.create(:user)
      get api_user_path(@user), headers: headers
    end

    it 'returns the information about a report on a hash' do
      user_response = json_response
      expect(user_response[:email]).to eq @user.email
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe 'POST /users' do
    context 'when the user is successfully created' do
      before(:each) do
        @user_attributes = FactoryBot.attributes_for(:user)
        post api_users_path, params: { user: @user_attributes }.to_json, headers: headers
      end

      it 'renders the json representation for the user record just created' do
        user_response = json_response
        expect(user_response[:email]).to eq @user_attributes[:email]
      end

      it { expect(response).to have_http_status(:created) }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_user_attributes = {
          password: '12345678',
          password_confirmation: '12345678'
        }
        post api_users_path, params: { user: @invalid_user_attributes }.to_json, headers: headers
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:email]).to include "can't be blank"
      end

      it { expect(response).to have_http_status(:unprocessable_content) }
    end
  end

  describe 'PUT/PATCH /users/:id' do
    context 'when is successfully updated' do
      before(:each) do
        @user = FactoryBot.create(:user)
        patch api_user_path(@user), params: { user: { email: 'newemail@example.com' } }.to_json, headers: headers
      end

      it 'updates the user email' do
        @user.reload
        expect(@user.email).to eq 'newemail@example.com'
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:email]).to eq 'newemail@example.com'
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when is not updated' do
      before(:each) do
        @user = FactoryBot.create(:user)
        patch api_user_path(@user), params: { user: { email: 'bademail.com' } }.to_json, headers: headers
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be updated' do
        expect(json_response[:errors][:email]).to include 'is invalid'
      end

      it { expect(response).to have_http_status(:unprocessable_content) }
    end
  end

  describe 'DELETE /users/:id' do
    before(:each) do
      @user = FactoryBot.create(:user)
      delete api_user_path(@user), headers: headers
    end

    it 'deletes the user' do
      expect(User.find_by(id: @user.id)).to be_nil
    end

    it { expect(response).to have_http_status(:no_content) }
  end
end
