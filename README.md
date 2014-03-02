# Appsignal::Grape

AppSignal intergation for [Grape][0], based on code from these [NewRelic][1] and [Liberato][2] gems.

[![Build Status](https://travis-ci.org/aai/grape-appsignal.png?branch=master)](http://travis-ci.org/aai/grape-appsignal)

## Installation

Add this line to your application's Gemfile:

    gem 'grape-appsignal'

Or install:

    $ gem install grape-appsignal

Include it in your Grape API like this

    class TestAPI < Grape::API
      use Appsignal::Grape::Middleware

      get 'hello' do
        "Hello World"
      end
    end

*Make sure you have already setup AppSignal for your app!*

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make a pull request

[0]: https://github.com/intridea/grape
[1]: https://github.com/flyerhzm/newrelic-grape
[2]: https://github.com/seanmoon/grape-librato
