require 'rails_helper'

describe ResponsesController, type: :controller do
  describe "GET #index" do
    it "responds with 200" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "responds with 200" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "responds with 200" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "responds with 200" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
