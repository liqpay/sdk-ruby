sdk-ruby
========

LiqPay Ruby sdk 


#### Настройка подключения ####
```ruby
liqpay = Liqpay::Liqpay.new(
  :public_key  => 'public_key',
  :private_key => 'private_key'
)
```

#### Создание кнопки для оплаты ####

```ruby
print liqpay.cnb_form(
  :amount      => "1.2",
  :currency    => "USD",
  :description => "my comment",
  :language    => "en"
)
```

### Возможные параметры ###

**параметр**                    | **обязательный**
--------------------------------|--------------------------------
`amount`                        | `Да`
`currency`                      | `Да`
`description`                   | `Да`
`order_id`                      | `Нет`
`result_url`                    | `Нет`
`server_url`                    | `Нет`
`type`                          | `Нет`
`language`                      | `Нет`
`order_id`                      | `Нет`

#### Создание сигнатуры для оплаты ####
```ruby
print liqpay.cnb_signature(
  :amount      => "1.2",
  :currency    => "USD",
  :description => "my comment",
  :language    => "en"
)
```

#### Проверка статуса платежа ####
```ruby
print liqpay.api(
  "payment/status",
  { 
    :order_id => "order_id_123"
  }
)['result']
```
