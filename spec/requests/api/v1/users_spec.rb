require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /users" do
    it "returns http success" do
      get "/users", headers: { "Host" => "api.example.com" }
      expect(response).to have_http_status(:success)
    end
  end
end
