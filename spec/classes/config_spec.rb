require 'spec_helper'

module Liqpay
  describe ::Liqpay::Config do
    before :each do
      ::Liqpay.configure do |c|
        c.private_key = 'private_key'
        c.public_key = 'public_key'
      end
    end

    it 'should have private key' do
      expect(::Liqpay.config.private_key).to eq 'private_key'
    end

    it 'should have public key' do
      expect(::Liqpay.config.public_key).to eq 'public_key'
    end

    it 'should reflect changes through block' do
      ::Liqpay.configure do |c|
        c.private_key = 'private_key3'
      end
      expect(::Liqpay.config.private_key).to eq 'private_key3'
    end
  end

end

