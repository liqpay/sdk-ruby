# encoding: utf-8

require 'net/http'
require 'uri'

module Liqpay
  class Client
    attr_accessor :options

    def initialize(options = {})
      @url = options[:host].to_s
    end

    def http_request(path, body)
      url = @url << path
      uri = URI.parse(url)
      timeout = 60

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.port == 443
      http.read_timeout = timeout

      response = http.request_post(uri.request_uri, body)
      response.body
    end

    def post(path, params)
      body = {:data => params[:data], :signature => params[:signature]}
      encoded_body = URI.encode_www_form(body)
      response = http_request(path, encoded_body)
      Coder.decode_json response
    end
  end # Client
end # Liqpay
