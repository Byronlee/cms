require "spec_helper"

describe MobileAdsController do
  describe "routing" do

    it "routes to #index" do
      get("/mobile_ads").should route_to("mobile_ads#index")
    end

    it "routes to #new" do
      get("/mobile_ads/new").should route_to("mobile_ads#new")
    end

    it "routes to #show" do
      get("/mobile_ads/1").should route_to("mobile_ads#show", :id => "1")
    end

    it "routes to #edit" do
      get("/mobile_ads/1/edit").should route_to("mobile_ads#edit", :id => "1")
    end

    it "routes to #create" do
      post("/mobile_ads").should route_to("mobile_ads#create")
    end

    it "routes to #update" do
      put("/mobile_ads/1").should route_to("mobile_ads#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/mobile_ads/1").should route_to("mobile_ads#destroy", :id => "1")
    end

  end
end
