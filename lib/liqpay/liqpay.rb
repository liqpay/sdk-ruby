# encoding: utf-8

# Liqpay Payment Module

# NOTICE OF LICENSE

# This source file is subject to the Open Software License (OSL 3.0)
# that is available through the world-wide-web at this URL:
# http://opensource.org/licenses/osl-3.0.php

# @category LiqPay
# @package LiqPay
# @version 0.0.1
# @author Liqpay
# @copyright Copyright (c) 2014 Liqpay
# @license http://opensource.org/licenses/osl-3.0.php Open Software License (OSL 3.0)

# EXTENSION INFORMATION

# LIQPAY API https://www.liqpay.com/ru/doc

# Payment method liqpay process

# @author Liqpay <support@liqpay.com>

# require 'rubygems'

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
      params[:public_key] = @public_key
      json_params = Coder.encode_json params
      sign_str = @private_key << json_params << @private_key
      signature = Coder.encode_signature sign_str

      data = {}
      data[:data] = json_params
      data[:signature] = signature

      @client.post(path, data)
    end # api

    def cnb_form(params = {})
      language = 'ru'
      language = params[:language] unless params[:language].nil?
      signature = (cnb_signature params).chomp
      
      params[:public_key] = @public_key
      params[:signature] = signature

      form = %Q(<form method="post" action="#{@host}pay" accept-charset="utf-8">\n)
      params.each do |key, value|
        form << %Q(<input type="hidden" name="#{key.to_s}" value="#{value.to_s}" />\n)
      end
      form << %Q(<input type="image" src="//static.liqpay.com/buttons/p1#{language}.radius.png" name="btn_text" />\n</form>\n)
    end # cnb_form

    def cnb_signature(params = {})
      amount = params[:amount].to_s if params.key? :amount
      currency = params[:currency].to_s if params.key? :currency
      description = params[:description].to_s if params.key? :description

      fail "Amount can't be empty" if amount.nil? or amount.empty?
      fail "Currency can't be empty" if currency.nil? or currency.empty?
      fail "Description can't be empty" if description.nil? or description.empty?

      sign_str = @private_key << amount << currency << @public_key
      
      sign_str << params[:order_id].to_s if params.key? :order_id
      sign_str << params[:type].to_s if params.key? :type
      sign_str << description
      sign_str << params[:result_url].to_s if params.key? :result_url
      sign_str << params[:server_url].to_s if params.key? :server_url
      sign_str << params[:sender_first_name].to_s if params.key? :sender_first_name
      sign_str << params[:sender_last_name].to_s if params.key? :sender_last_name
      sign_str << params[:sender_middle_name].to_s if params.key? :sender_middle_name
      sign_str << params[:sender_country].to_s if params.key? :sender_country
      sign_str << params[:sender_city].to_s if params.key? :sender_city
      sign_str << params[:sender_address].to_s if params.key? :sender_address
      sign_str << params[:sender_postal_code].to_s if params.key? :sender_postal_code

      Coder.encode_signature sign_str.to_s
    end # cnb_signature

    def str_to_sign(str)
      Coder.encode_signature str
    end # str_to_sign
  end # Liqpay
end # Liqpay
