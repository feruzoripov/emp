# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  context 'validations' do
    it 'should active by default' do
      expect(user.active?).to eq true
    end

    it 'should be with unique email' do
      expect { User.create!(email: user.email, name: 'test', password: 'password') }.to raise_error
    end
  end

  context 'destroy' do
    it 'should be deleted if there are NO transactions' do
      expect { user.destroy }.to_not raise_error
    end

    let(:transaction1) { create(:authorize, merchant: user) }
    let(:transaction2) { create(:charge, merchant: user) }

    it 'should NOT be deleted if there are transactions' do
      transaction1.reload
      transaction2.reload
      expect(user.destroy).to eq false
    end
  end
end
