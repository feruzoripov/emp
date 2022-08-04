# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
  describe 'GET /transactions' do
    context 'withour auth' do
      it 'returns 401 code' do
        get '/transactions'
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }

      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      context 'no transaction' do
        it 'should list all transactions of merchant' do
          get '/transactions', headers: { 'Authorization': @token }
          expect(response).to have_http_status(200)
          expect(response.parsed_body).to eq []
        end
      end

      context 'with transactions' do
        let(:transaction1) { create(:authorize, merchant: user) }
        let(:transaction2) { create(:charge, merchant: user) }
        let(:transaction3) { create(:refund, merchant: user) }
        let(:transaction4) { create(:reversal, merchant: user) }

        before do
          [transaction1, transaction2, transaction3, transaction4].each(&:reload)
        end

        it 'should list all transactions of merchant' do
          get '/transactions', headers: { 'Authorization': @token }
          expect(response).to have_http_status(200)
          expect(response.parsed_body).to_not be_empty
        end
      end
    end
  end

  describe 'POST /transactions/authorize' do
    context 'withour auth' do
      it 'returns 401 code' do
        post '/transactions/authorize'
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }

      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      context 'invalid params' do
        it 'should raise error with invalid params' do
          expect do
            post '/transactions/authorize', params: {}, headers: { 'Authorization': @token }
          end.to raise_error
        end
      end

      context 'valid params' do
        let(:params) { { customer_email: 'test@test.com', customer_phone: '123123', amount: '123' } }

        it 'returns uuid of created authorized transaction' do
          post '/transactions/authorize', params: params, headers: { 'Authorization': @token }
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'POST /transactions/charge' do
    context 'withour auth' do
      it 'returns 401 code' do
        post '/transactions/charge'
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }

      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      context 'invalid params' do
        it 'should raise error with invalid params' do
          expect do
            post '/transactions/charge', params: {}, headers: { 'Authorization': @token }
          end.to raise_error
        end

        let(:params) { { uuid: '', amount: '123' } }

        it 'should create transaction with :error status' do
          post '/transactions/charge', params: params, headers: { 'Authorization': @token }
          expect(response).to have_http_status(200)
          expect(Transaction::Charge.last.error?).to eq true
          expect(user.reload.total_transaction_sum).to eq(0)
        end
      end

      context 'valid params' do
        let(:authorized_t) { create(:authorize, merchant: user) }
        let(:params) { { uuid: authorized_t.reload.uuid, amount: '123' } }

        it 'returns uuid of created authorized transaction' do
          post '/transactions/charge', params: params, headers: { 'Authorization': @token }
          expect(response).to have_http_status(200)
          expect(user.reload.total_transaction_sum).to eq(123)
        end
      end
    end
  end

  describe 'POST /transactions/refund' do
    context 'withour auth' do
      it 'returns 401 code' do
        post '/transactions/refund'
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }

      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      context 'invalid params' do
        it 'should raise error with invalid params' do
          expect do
            post '/transactions/refund', params: {}, headers: { 'Authorization': @token }
          end.to raise_error
        end

        let(:params) { { uuid: '', amount: '123' } }

        it 'should create transaction with :error status' do
          user.update_attribute(:total_transaction_sum, 10)
          post '/transactions/refund', params: params, headers: { 'Authorization': @token }
          expect(response).to have_http_status(200)
          expect(Transaction::Refund.last.error?).to eq true
          expect(user.reload.total_transaction_sum).to eq(10)
        end
      end

      context 'valid params' do
        let(:charged_t) { create(:charge, merchant: user) }
        let(:params) { { uuid: charged_t.reload.uuid, amount: '10' } }

        it 'returns uuid of created authorized transaction' do
          user.update_attribute(:total_transaction_sum, 20)
          post '/transactions/refund', params: params, headers: { 'Authorization': @token }
          expect(response).to have_http_status(200)
          expect(user.reload.total_transaction_sum).to eq(10)
          expect(Transaction::Refund.last.approved?).to eq true
          expect(charged_t.reload.refunded?).to eq true
        end
      end
    end
  end

  describe 'POST /transactions/reverse' do
    context 'withour auth' do
      it 'returns 401 code' do
        post '/transactions/reverse'
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }

      before do
        post '/auth/login', params: { email: user.email, password: 'password' }
        @token = response.parsed_body['token']
      end

      context 'invalid params' do
        let(:params) { { uuid: '' } }

        it 'should create transaction with :error status' do
          post '/transactions/reverse', params: params, headers: { 'Authorization': @token }
          expect(response).to have_http_status(200)
          expect(Transaction::Reversal.last.error?).to eq true
        end
      end

      context 'valid params' do
        let(:authorized_t) { create(:authorize, merchant: user) }
        let(:params) { { uuid: authorized_t.reload.uuid } }

        it 'returns uuid of created authorized transaction' do
          post '/transactions/reverse', params: params, headers: { 'Authorization': @token }
          expect(response).to have_http_status(200)
          expect(authorized_t.reload.reversed?).to eq true
        end
      end
    end
  end
end
