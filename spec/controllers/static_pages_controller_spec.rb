require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe StaticPagesController, type: :controller do
  describe "GET home" do
    before do
      get :home
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render new football pitch form" do
      expect(response).to render_template(:home)
    end
  end

  describe "GET help" do
    before do
      get :help
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render new football pitch form" do
      expect(response).to render_template(:help)
    end
  end

  describe "GET about" do
    before do
      get :about
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render new football pitch form" do
      expect(response).to render_template(:about)
    end
  end

  describe "GET contact" do
    before do
      get :contact
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render new football pitch form" do
      expect(response).to render_template(:contact)
    end
  end
end
