require 'rails_helper'

describe ScenarioController, type: :controller do

  describe 'timeout' do
    it "returns http success after 5 seconds when no param" do
      start = Time.now
      get :timeout
      finish = Time.now

      expect(response).to have_http_status(:success)
      expect(finish.to_i - start.to_i).to eq 5
    end

    it "returns http success after based on the time param" do
      start = Time.now
      get :timeout, time: 2
      finish = Time.now

      expect(response).to have_http_status(:success)
      expect(finish.to_i - start.to_i).to eq 2
    end
  end

  describe 'not_found' do
    it "returns http 404 response" do
      get :not_found
      expect(response.status).to eq 404
    end
  end

  describe 'server_error' do
    it "returns http 500 response" do
      get :server_error
      expect(response.status).to eq 500
    end
  end

  describe 'index' do
    it "returns http success response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
