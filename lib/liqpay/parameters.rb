# encoding: utf-8
# -*- frozen-string-literal: true -*-

module Liqpay
  module Parameters
    extend self

    def normalize(params)
      params
        .map do |key, value|
          [ key.to_sym, (Enumerable === value ? value : value.to_s) ]
        end
        .to_h
    end

    def validate_presence!(params, *keys)
      keys.each do |key|
        param = params[ key ].to_s
        if param.nil? || param.empty?
          fail("%s can't be empty" % key.to_s.capitalize)
        end
      end
    end

  end # Parameters
end # Liqpay
