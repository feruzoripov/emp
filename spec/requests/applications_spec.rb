require 'rails_helper'

RSpec.describe "Applications", type: :request do
  describe "GET /applications" do
    it "requires authorization" do
      get '/status'
      expect(response).to have_http_status(401)
    end

    context 'authorized' do
      let(:user) { create(:user) }

      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      it 'should be ok' do
        get '/status', headers: {'Authorization': @token}
        expect(response).to have_http_status(200)
      end
    end
  end
end
