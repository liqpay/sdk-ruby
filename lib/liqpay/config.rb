# encoding: utf-8
# -*- frozen-string-literal: true -*-

module Liqpay
  class Config
    attr_accessor :private_key, :public_key, :version, :server_url, :return_url

    def initialize
      @private_key = ENV['LIQPAY_PRIVATE_KEY']
      @public_key  = ENV['LIQPAY_PUBLIC_KEY']
      @version = 3
    end

  end
end
