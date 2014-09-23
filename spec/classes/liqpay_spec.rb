require './lib/liqpay/liqpay'
require './lib/liqpay/client'
require './lib/liqpay/coder'

describe :cnd_form do
  let(:liqpay_empty) { Liqpay::Liqpay.new(
    :host => '',
    :private_key => '',
    :public_key => ''
  )}
  let(:liqpay_full) { Liqpay::Liqpay.new(
    :host => 'https://www.liqpay.com/api/',
    :private_key => 'private_key',
    :public_key => 'public_key'
  )}
  context 'when creating form' do
    it 'does not create form without amount field' do
      expect {
        Liqpay::Liqpay.new.cnb_form()
      }.to raise_error(RuntimeError,"Amount can't be empty")
    end
    it 'does not create form without currency field' do
      expect {
        Liqpay::Liqpay.new.cnb_form(
          :amount => '1'
        )
      }.to raise_error(RuntimeError,"Currency can't be empty")
    end
    it 'does not create form without description field' do
      expect {
        Liqpay::Liqpay.new.cnb_form(
          :amount   => '1',
          :currency => 'USD'
        )
      }.to raise_error(RuntimeError,"Description can't be empty")
    end
    it 'does not create form with empty fields' do
      expect {
        Liqpay::Liqpay.new.cnb_form(
          :amount      => '',
          :currency    => '',
          :description => ''
        )
      }.to raise_error(RuntimeError,"Amount can't be empty")
    end
    it 'does not create form without options' do
      expect {
        Liqpay::Liqpay.new.cnb_form(
          :amount      => '1',
          :currency    => 'USD',
          :description => 'test'
        )
      }.to raise_error(NoMethodError,"undefined method `<<' for nil:NilClass")
    end
  end
  context 'when creating form with options' do
    it 'creates form when options was set' do
        liqpay_empty.cnb_form(
          :amount      => '1',
          :currency    => 'USD',
          :description => 'test'
        ).should match(/u50UwZfQmiGpGo3AmhYIDfjmCb4/)
    end
    it 'creates form with extra param when options was empty' do
      liqpay_empty.cnb_form(
        :amount      => "3940",
        :currency    => "UAH",
        :description => "description",
        :test        => "cccc"
      ).should match(/"xWXss8LoJAh7QJ9kv\+QTPu8UIrE/)
    end
    it 'creates form when options was set' do
      liqpay_full.cnb_form(
        :amount      => "1.2",
        :currency    => "USD",
        :description => "my comment",
        :language    => "en"
      ).should match(/"Bi2FxqSmM2A5ZFt5l397f\/QSyQM=/)
    end
  end

  describe :api do
    it 'receives code 500 with invalid keys' do
      liqpay_full.api(
        "payment/status",
        { :order_id => "order_id_123" }
      ).should eq({"result"=>"error", "description"=>"invalid_json"})
    end
  end
end
