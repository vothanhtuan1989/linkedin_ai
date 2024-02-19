require 'rails_helper'

RSpec.describe "ChatResponses", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/chat_responses/show"
      expect(response).to have_http_status(:success)
    end
  end

end
