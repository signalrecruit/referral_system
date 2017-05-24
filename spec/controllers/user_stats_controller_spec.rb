require 'rails_helper'

RSpec.describe UserStatsController, type: :controller do

  describe "GET #statistics" do
    it "returns http success" do
      get :statistics
      expect(response).to have_http_status(:success)
    end
  end

end
