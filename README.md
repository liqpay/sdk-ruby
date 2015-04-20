# Ruby gem for LiqPay.com API

Ruby gem wrapper for official Liqpay SDK https://github.com/liqpay/sdk-ruby

## Installation

Add the gem to your Gemfile:

```ruby
gem 'novaposhta2', github: 'kukareka/novaposhta2'
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

```ruby
require 'liqpay'
liqpay = Liqpay.new
liqpay.api 'invoice/send', { email: 'test@example.com', amount: 100, currency: 'UAH',
  order_id: 1,
  goods: [{
              amount: 100,
              count: 1,
              unit: 'pcs',
              name: 'Order' }]}
```

Full Liqpay API documentation is available on https://www.liqpay.com/en/doc

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





