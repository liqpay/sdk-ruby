# encoding: utf-8
# -*- frozen-string-literal: true -*-

require 'net/http'
require 'uri'

module Liqpay
  class Client
    API_URL = 'https://www.liqpay.com/api/'

    attr_reader :api_uri

    def initialize(api_url = nil)
      @api_uri = URI.parse(api_url || API_URL)
    end

    def post(path, data, signature)
      params = { data: data, signature: signature }
      uri = endpoint(path)
      # read_timeout is 60seec by default
      response = Net::HTTP.post_form(uri, params)
      Coder.decode_json(response.body)
    end

    def endpoint(path)
      api_uri + path
    end

  end # Client
end # Liqpay
