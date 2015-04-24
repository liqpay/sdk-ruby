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
   it 'should be able to send and cancel invoices' do
     order_id = rand(1000)
     r = @liqpay.api 'invoice/send', { email: 'test@example.com', amount: 100, currency: 'UAH',
                                   order_id: order_id,
                                   goods: [{
                                               amount: 100,
                                               count: 1,
                                               unit: 'Order',
                                               name: "Order #{order_id}" }]}
     expect(r['result']).to eq 'ok'
     r = @liqpay.api 'invoice/cancel', {order_id: order_id}
     expect(r['result']).to eq 'ok'

   end
 end
end
