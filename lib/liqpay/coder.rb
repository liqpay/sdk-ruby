# encoding: utf-8

require 'base64'
require 'digest/sha1'
require 'json'

module Liqpay
  module Coder
    extend self

    def encode_signature(param)
      sha1 = Digest::SHA1.digest(param)
      #Base64.strict_encode64(sha1)
      encode64(sha1)
    end

    def encode64_json(params)
      encode64(encode_json(params))
    end

    def decode64_json(data)
      decode_json(Base64.decode64(data))
    end

    def encode_json(params)
      JSON.generate(params)
    end

    def decode_json(json)
      JSON.parse(json)
    end

    def encode64(param)
      Base64.strict_encode64(param)
    end

  end # Coder
end # Liqpay
