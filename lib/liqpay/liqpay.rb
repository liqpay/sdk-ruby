# encoding: utf-8
# -*- frozen-string-literal: true -*-

# Liqpay Payment Module

# NOTICE OF LICENSE

# This source file is subject to the Open Software License (OSL 3.0)
# that is available through the world-wide-web at this URL:
# http://opensource.org/licenses/osl-3.0.php

# @category LiqPay
# @package LiqPay
# @version 0.0.3
# @author Liqpay
# @copyright Copyright (c) 2014 Liqpay
# @license http://opensource.org/licenses/osl-3.0.php Open Software License (OSL 3.0)

# EXTENSION INFORMATION

# LIQPAY API https://www.liqpay.ua/documentation/en

# Payment method liqpay process

# @author Liqpay <support@liqpay.ua>

module Liqpay
  class Liqpay
    attr_reader :client, :public_key, :private_key

    AVAILABLE_LANGUAGES = ['ru', 'uk', 'en']
    BUTTON_TEXTS = { ru: 'Оплатить', uk: 'Сплатити', en: 'Pay' }

    def initialize(options = {})
      @public_key  = options[:public_key]  || ::Liqpay.config.public_key
      @private_key = options[:private_key] || ::Liqpay.config.private_key
      @client = Client.new
    end

    def api(path, params)
      params = normalize_and_check(params, api_defaults, :version)

      data, signature = data_and_signature(params)

      client.post(path, data, signature)
    end

    def checkout_url(params)
      params = normalize_and_check(params, api_defaults, :version, :action, :amount, :currency, :description, :order_id)
      language = if AVAILABLE_LANGUAGES.include?(params[:language])
                   params[:language]
                 else
                   'uk'
                 end

      data, signature = data_and_signature(params)

      client.endpoint("3/checkout?data=#{data}&signature=#{signature}&language=#{language}")
    end

    def cnb_form(params)
      params = normalize_and_check(params, {}, :version, :amount, :currency, :description)
      language = if AVAILABLE_LANGUAGES.include?(params[:language])
                   params[:language]
                 else
                   'uk'
                 end

      data, signature = data_and_signature(params)

      HTML_FORM % [client.endpoint('3/checkout'), data, signature, BUTTON_TEXTS[language.to_sym]]
    end

    def match?(data, signature)
      signature == encode_signature(data)
    end

    def decode_data(data)
      Coder.decode64_json(data)
    end

    def encode_signature(data)
      str = private_key + data + private_key
      Coder.encode_signature(str)
    end

    # Useless method for backward compatibility
    def cnb_signature(params = {})
      warn 'DEPRECATION WARNING: the method cnb_signature is deprecated.'
      params = normalize_and_check(params, {}, :version, :amount, :currency, :description)
      data_and_signature(params).last
    end

    # Useless method for backward compatibility
    def str_to_sign(str)
      warn 'DEPRECATION WARNING: the method str_to_sign is deprecated. Use encode_signature insted.'
      Coder.encode_signature str
    end

    private

    def normalize_and_check(params, defaults, *check_keys)
      nomalized = Parameters.normalize(params)
      defaults.merge!(nomalized).tap do |result|
        Parameters.validate_presence!(result, *check_keys)
        result[:public_key] = public_key
      end
    end

    def api_defaults
      {
        version:    ::Liqpay.config.version.to_s,
        server_url: ::Liqpay.config.server_url,
        return_url: ::Liqpay.config.return_url,
      }
    end

    def data_and_signature(params)
      base64_json = Coder.encode64_json(params)
      [base64_json, encode_signature(base64_json)]
    end

    HTML_FORM = <<-FORM_CODE
<form method="post" action="%s" accept-charset="utf-8">
<input type="hidden" name="data" value="%s" />
<input type="hidden" name="signature" value="%s" />
<script type="text/javascript" src="https://static.liqpay.ua/libjs/sdk_button.js"></script>
<sdk-button label="%s" background="#77CC5D" onClick="submit()"></sdk-button>
</form>
    FORM_CODE

  end # Liqpay
end # Liqpay
