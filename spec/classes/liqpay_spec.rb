# encoding: utf-8

require './lib/liqpay/liqpay'
require './lib/liqpay/client'
require './lib/liqpay/coder'

describe :cnd_form do
  let(:liqpay_empty) { Liqpay::Liqpay.new(
    :private_key => '',
    :public_key  => ''
  )}
  let(:liqpay_full) { Liqpay::Liqpay.new(
    :private_key => 'private_key',
    :public_key  => 'public_key'
  )}
  context 'when creating form' do
    it 'does not create form without version field' do
      expect {
        Liqpay::Liqpay.new.cnb_form()
      }.to raise_error(RuntimeError,"Version can't be empty")
    end
    it 'does not create form without amount field' do
      expect {
        Liqpay::Liqpay.new.cnb_form(
          :version => "3"
        )
      }.to raise_error(RuntimeError,"Amount can't be empty")
    end
    it 'does not create form without currency field' do
      expect {
        Liqpay::Liqpay.new.cnb_form(
          :version => "3",
          :amount  => "1"
        )
      }.to raise_error(RuntimeError,"Currency can't be empty")
    end
    it 'does not create form without description field' do
      expect {
        Liqpay::Liqpay.new.cnb_form(
          :version  => "3",
          :amount   => "1",
          :currency => "UAH"
        )
      }.to raise_error(RuntimeError,"Description can't be empty")
    end
    it 'does not create form without private key' do
      expect {
        Liqpay::Liqpay.new.cnb_form(
          :version     => "3",
          :amount      => "1",
          :currency    => "UAH",
          :description => "my comment"
        )
      }.to raise_error(NoMethodError,"undefined method `+' for nil:NilClass")
    end
    it 'creates form with empty keys' do
      expect(
        liqpay_empty.cnb_form(
          :version     => "3",
          :amount      => "1",
          :currency    => "UAH",
          :description => "my comment"
        )
      ).to eq("<form method=\"post\" action=\"https://www.liqpay.com/api/checkout\" accept-charset=\"utf-8\">\n<input type=\"hidden\" name=\"data\" value=\"eyJ2ZXJzaW9uIjoiMyIsImFtb3VudCI6IjEiLCJjdXJyZW5jeSI6IlVBSCIs\nImRlc2NyaXB0aW9uIjoibXkgY29tbWVudCIsInB1YmxpY19rZXkiOiIifQ==\" />\n<input type=\"hidden\" name=\"signature\" value=\"8TbC+sqO0WtfWd5Q0GQq4eJRpNk=\" />\n<input type=\"image\" src=\"//static.liqpay.com/buttons/p1ru.radius.png\" name=\"btn_text\" />\n</form>\n")
    end
    it 'creates form with not empty keys' do
      expect(
        liqpay_full.cnb_form(
          :version     => "3",
          :amount      => "1",
          :currency    => "UAH",
          :description => "my comment"
        )
      ).to eq("<form method=\"post\" action=\"https://www.liqpay.com/api/checkout\" accept-charset=\"utf-8\">\n<input type=\"hidden\" name=\"data\" value=\"eyJ2ZXJzaW9uIjoiMyIsImFtb3VudCI6IjEiLCJjdXJyZW5jeSI6IlVBSCIs\nImRlc2NyaXB0aW9uIjoibXkgY29tbWVudCIsInB1YmxpY19rZXkiOiJwdWJs\naWNfa2V5In0=\" />\n<input type=\"hidden\" name=\"signature\" value=\"01DQQD+qsiK3kA8bZFeOI+tEhIo=\" />\n<input type=\"image\" src=\"//static.liqpay.com/buttons/p1ru.radius.png\" name=\"btn_text\" />\n</form>\n")
    end
  end
end

describe :api do
  let(:liqpay_full) { Liqpay::Liqpay.new(
    :private_key => 'private_key',
    :public_key  => 'public_key'
  )}
  context 'when creating api request' do
    it 'does not create request without version field' do
      expect{liqpay_full.api("payment/pay",{})
      }.to raise_error(RuntimeError,"Version can't be empty")
    end
=begin
    it 'returns err_access for pay request' do
      expect(liqpay_full.api("payment/pay",{
          :version => "3"
        })
      ).to eq({"code"=>"err_access", "result"=>"err_access"})
    end
    it 'returns err_access for pay request' do
      expect(liqpay_full.api("payment/status",{
          :version  => "3",
          :order_id => "test"
        })
      ).to eq({"result"=>"error", "description"=>"payment_not_found"})
    end
    it 'returns err_access for pay request' do
      expect(liqpay_full.api("payment/status",{
          :version  => "3",
          :order_id => "тест"
        })
      ).to eq({"result"=>"error", "description"=>"payment_not_found"})
    end
=end
  end
end