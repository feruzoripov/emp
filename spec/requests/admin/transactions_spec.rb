require 'rails_helper'

RSpec.describe "Admin::Transactions", type: :request do
  let(:user) { create(:user, admin: true) }

  let!(:transaction1) { create(:authorize, merchant: user) }
  let!(:transaction2) { create(:charge, merchant: user, parent_transaction: transaction1) }
  let!(:transaction3) { create(:refund, merchant: user, parent_transaction: transaction2) }
  let!(:transaction4) { create(:reversal, merchant: user) }

  describe "GET /authorize" do
    context 'unauthorized' do
      it 'returns 401 error' do
        get '/admin/transactions/authorize'
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized, not admin' do
      let(:user) { create(:user) }

      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      it 'returns not admin error' do
        get '/admin/transactions/authorize', headers: { 'Authorization': @token }
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized, admin' do
      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      let(:expected_response) do
        [{
          uuid: transaction1.reload.uuid,
          type: transaction1.type,
          customer_email: transaction1.customer_email,
          customer_phone: transaction1.customer_phone,
          status: transaction1.status,
          amount: transaction1.amount.to_s,
          parent_transaction_uuid: nil,
          merchant_id: user.id
        }.stringify_keys]
      end

      it 'returns success' do
        get '/admin/transactions/authorize', headers: { 'Authorization': @token }
        expect(response).to have_http_status(200)
        expect(response.parsed_body).to eq expected_response
      end
    end
  end

  describe "GET /charge" do
    context 'unauthorized' do
      it 'returns 401 error' do
        get '/admin/transactions/charge'
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized, not admin' do
      let(:user) { create(:user) }

      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      it 'returns not admin error' do
        get '/admin/transactions/charge', headers: { 'Authorization': @token }
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized, admin' do
      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      let(:expected_response) do
        [{
          uuid: transaction2.reload.uuid,
          type: transaction2.type,
          customer_email: transaction2.customer_email,
          customer_phone: transaction2.customer_phone,
          status: transaction2.status,
          amount: transaction2.amount.to_s,
          parent_transaction_uuid: transaction1.reload.uuid,
          merchant_id: user.id
        }.stringify_keys]
      end

      it 'returns success' do
        get '/admin/transactions/charge', headers: { 'Authorization': @token }
        expect(response).to have_http_status(200)
        expect(response.parsed_body).to eq expected_response
      end
    end
  end

  describe "GET /refund" do
    context 'unauthorized' do
      it 'returns 401 error' do
        get '/admin/transactions/refund'
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized, not admin' do
      let(:user) { create(:user) }

      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      it 'returns not admin error' do
        get '/admin/transactions/refund', headers: { 'Authorization': @token }
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized, admin' do
      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      let(:expected_response) do
        [{
          uuid: transaction3.reload.uuid,
          type: transaction3.type,
          customer_email: transaction3.customer_email,
          customer_phone: transaction3.customer_phone,
          status: transaction3.status,
          amount: transaction3.amount.to_s,
          parent_transaction_uuid: transaction2.reload.uuid,
          merchant_id: user.id
        }.stringify_keys]
      end

      it 'returns success' do
        get '/admin/transactions/refund', headers: { 'Authorization': @token }
        expect(response).to have_http_status(200)
        expect(response.parsed_body).to eq expected_response
      end
    end
  end

  describe "GET /reversal" do
    let!(:transaction4) { create(:reversal, merchant: user, parent_transaction: transaction1) }
    context 'unauthorized' do
      it 'returns 401 error' do
        get '/admin/transactions/reversal'
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized, not admin' do
      let(:user) { create(:user) }

      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      it 'returns not admin error' do
        get '/admin/transactions/reversal', headers: { 'Authorization': @token }
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized, admin' do
      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      let(:expected_response) do
        [{
          uuid: transaction4.reload.uuid,
          type: transaction4.type,
          customer_email: transaction4.customer_email,
          customer_phone: transaction4.customer_phone,
          status: transaction4.status,
          amount: nil,
          parent_transaction_uuid: transaction1.reload.uuid,
          merchant_id: user.id
        }.stringify_keys]
      end

      it 'returns success' do
        get '/admin/transactions/reversal', headers: { 'Authorization': @token }
        expect(response).to have_http_status(200)
        expect(response.parsed_body).to eq expected_response
      end
    end
  end

  describe 'POST /admin/transactions/del_old' do
    context 'authorized, admin' do
      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      it 'should run sidekiq job to delete old transactions' do
        expect(ClearTransactionsJob).to receive(:perform_async)
        post '/admin/transactions/del_old', headers: { 'Authorization': @token }
      end
    end
  end
end
