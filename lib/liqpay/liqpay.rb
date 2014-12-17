# encoding: utf-8

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

# LIQPAY API https://www.liqpay.com/ru/doc

# Payment method liqpay process

# @author Liqpay <support@liqpay.com>

module Liqpay
  class Liqpay
    def initialize(options = {})
      @host = 'https://www.liqpay.com/api/'
      options[:host] = @host
      @public_key = options[:public_key] if options.key? :public_key
      @private_key = options[:private_key] if options.key?  :private_key
      @client = Client.new(options)
    end

    def api(path, params)
      fail "Version can't be empty" if params[:version].nil? or params[:version].empty?
      params[:public_key] = @public_key
      json_params = Coder.encode64 Coder.encode_json params
      sign_str = @private_key + json_params + @private_key
      signature = Coder.encode_signature sign_str
      data = {}
      data[:data] = json_params
      data[:signature] = signature

      @client.post(path, data)
    end # api

    def cnb_form(params = {})
      fail "Version can't be empty" if params[:version].nil? or params[:version].empty?
      language = 'ru'
      language = params[:language] unless params[:language].nil?
      params[:public_key] = @public_key
      json_params = Coder.encode64 Coder.encode_json params
      signature = cnb_signature params

      form  = %Q(<form method="post" action="#{@host}checkout" accept-charset="utf-8">\n)
      form << %Q(<input type="hidden" name="data" value="#{json_params.to_s}" />\n)
      form << %Q(<input type="hidden" name="signature" value="#{signature.to_s}" />\n)
      form << %Q(<input type="image" src="//static.liqpay.com/buttons/p1#{language}.radius.png" name="btn_text" />\n</form>\n)
    end # cnb_form

    def cnb_signature(params = {})
      version = params[:version].to_s if params.key? :version
      amount = params[:amount].to_s if params.key? :amount
      currency = params[:currency].to_s if params.key? :currency
      description = params[:description].to_s if params.key? :description

      fail "Version can't be empty" if version.nil? or version.empty?
      fail "Amount can't be empty" if amount.nil? or amount.empty?
      fail "Currency can't be empty" if currency.nil? or currency.empty?
      fail "Description can't be empty" if description.nil? or description.empty?

      params[:public_key] = @public_key

      json_params = Coder.encode64 (Coder.encode_json params)
      sign_str = @private_key + json_params + @private_key
      Coder.encode_signature sign_str.to_s
    end # cnb_signature

    def str_to_sign(str)
      Coder.encode_signature str
    end # str_to_sign
  end # Liqpay
end # Liqpay
