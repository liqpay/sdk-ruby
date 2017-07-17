require 'spec_helper'

begin
require File.expand_path('../../../dummy/config.rb', __FILE__) unless ENV['LIQPAY_PUBLIC_KEY'] && ENV['LIQPAY_PRIVATE_KEY']
rescue LoadError
  puts "Could not load API keys. Please provide API keys in ENV['LIQPAY_PUBLIC_KEY'] && ENV['LIQPAY_PRIVATE_KEY'] or spec/dummy/config.rb"
end

module Liqpay
  describe 'Invoice API' do
    before :all do
      @liqpay = Liqpay.new
    end
    it 'should be able to send and cancel invoices', real: true do
      email = ENV[ 'TEST_EMAIL' ] || 'test@example.com'
      order_id = 'test-%s-%s' % [Time.now.to_i.to_s(16), rand(1000)]
      r = @liqpay.api('request', {
        action:   'invoice_send',
        version:  '3',
        email:    email,
        amount:   '1',
        currency: 'USD',
        order_id: order_id,
        goods:    [{
          amount: 100,
          count:  2,
          unit:   'шт.',
          name:   'телефон'
        }]
      })

      expect(r['result']).to eq 'ok'
      # r = @liqpay.api 'invoice/cancel', {order_id: order_id}
      r = @liqpay.api('request', {
        action:   'invoice_cancel',
        version:  '3',
        order_id: order_id
      })
      expect(r['result']).to eq 'ok'

    end
  end
end
