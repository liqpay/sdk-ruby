# encoding: utf-8

require 'base64'
require 'digest/sha1'
require 'json'

module Liqpay
  class Coder
    def self.encode_signature param
      sha1 = Digest::SHA1.digest(param)
      Base64.encode64 sha1
    end # encode_signature

    def self.encode_json(params)
      JSON.generate(params)
    end # encode_json

    def self.decode_json(json)
      JSON.parse(json)
    end # decode_json
  end # Coder
end # Liqpay
