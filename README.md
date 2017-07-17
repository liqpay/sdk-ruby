# Ruby gem for LiqPay.com API

Ruby gem wrapper for official Liqpay SDK https://github.com/liqpay/sdk-ruby

## Installation

Add the gem to your Gemfile:

```ruby
gem 'liqpay', github: 'liqpay/sdk-ruby'
```

And don't forget to run Bundler:

```shell
$ bundle install
```

## Configuration

Get API keys on https://www.liqpay.com/ and save them in config:
 
```ruby
# config/initializers/liqpay.rb

::Liqpay.configure do |config|
  config.public_key = 'public_key'
  config.private_key = 'private_key'
end
```

You can also store API keys in `ENV['LIQPAY_PUBLIC_KEY']` and `ENV['LIQPAY_PRIVATE_KEY']`

## Usage

Full Liqpay API documentation is available on https://www.liqpay.com/en/doc

### Api

```ruby
require 'liqpay'
liqpay = Liqpay.new
liqpay.api('request', {
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
```

### Checkout

```ruby
html = liqpay.cnb_form({
  action:      "pay",
  amount:      "1",
  currency:    "USD",
  description: "description text",
  order_id:    "order_id_1",
  version:     "3"
})
```

### Callback

```ruby
data      = request.parameters['data']
signature = request.parameters['signature']

if liqpay.match?(data, signature)
  responce_hash = liqpay.decode_data(data)
  # Check responce_hash['status'] and process due to Liqpay API documentation.
else
# Wrong signature!
end
```

## Tests

To pass the API tests, specify API keys in `ENV['LIQPAY_PUBLIC_KEY']` and `ENV['LIQPAY_PRIVATE_KEY']`
or in `spec/dummy/config.rb`:

```ruby
# spec/dummy/config.rb
::Liqpay.configure do |config|
  config.public_key = 'public_key'
  config.private_key = 'private_key'
end
```
To run local only tests(keys are not required), execute
```
rspec --tag ~@real
```

With real api test you can specify email to recive invoce from Liqpay:
```
LIQPAY_PUBLIC_KEY=real_public_key LIQPAY_PRIVATE_KEY=real_private_key TEST_EMAIL=real_email rspec --tag @real
```
