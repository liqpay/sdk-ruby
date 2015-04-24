Gem::Specification.new do |s|
  s.name        = 'liqpay'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Oleg Kukareka']
  s.email       = 'oleg@kukareka.com'
  s.homepage    = 'https://github.com/kukareka/liqpay'
  s.summary     = 'LiqPay.com Ruby SDK'
  s.description = 'Gem wrapper for official liqpay/sdk-ruby'
  s.homepage    = 'https://github.com/kukareka/liqpay'
  s.required_ruby_version = '>= 1.9'

  s.rubyforge_project         = 'liqpay'

  s.files        = Dir['{lib}/**/*.rb']
  s.require_path = 'lib'
end