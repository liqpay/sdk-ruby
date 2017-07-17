lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'liqpay/version'

Gem::Specification.new do |s|
  s.name        = 'liqpay'
  s.version     = Liqpay::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Oleg Kukareka']
  s.email       = 'oleg@kukareka.com'
  s.homepage    = 'https://github.com/liqpay/sdk-ruby/'
  s.summary     = 'LiqPay.com Ruby SDK'
  s.description = 'Gem wrapper for official liqpay/sdk-ruby'
  s.required_ruby_version = '>= 1.9'

  s.rubyforge_project         = 'liqpay'

  s.files        = Dir['{lib}/**/*.rb']
  s.require_path = 'lib'
end
