# SpikePay

[SPIKE](https://spike.cc/) Payment service API client for Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'spike_pay'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spike_pay

## Usage

```
require 'spike_pay'

spike = SpikePay.new('sk_test_your_private_key')

param = {
   currency: 'JPY',
   amount: 1000,
   card: 'tok_card_token_from_spike_checkout',
   products: [{
       id: '00001',
       title: 'item',
       description: 'item description',
       language: 'JA',
       price: 1000,
       currency: 'JPY',
       count: 1,
       stock: 1
   }]
}

# Charge
response = spike.charge.create(param)

# Refund
spike.charge.refund(response["id"])

# Retrieve
spike.charge.retrieve(response["id"])

# All Charges
spike.charge.all({limit: 50})
```

## Contributing

1. Fork it ( https://github.com/honkimi/spike_pay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

