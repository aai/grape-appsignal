# Appsignal::Grape

[AppSignal][0] intergation for [Grape][1], based on code from these [NewRelic][2] and [Liberato][3] gems.

[![Build Status](https://travis-ci.org/aai/grape-appsignal.png?branch=master)](http://travis-ci.org/aai/grape-appsignal)

## Installation

Add this line to your application's Gemfile:

    gem 'grape-appsignal', '~> 0.1.1'

Or install:

    $ gem install grape-appsignal

Include it in your Grape API like this

    class TestAPI < Grape::API
      # Make sure this is at the top of the class.
      # If you are mounting other APIs it only needs to go into the base API
      use Appsignal::Grape::Middleware

      helpers Helpers
      mount ProfileAPI

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

[0]: https://appsignal.com
[1]: https://github.com/intridea/grape
[2]: https://github.com/flyerhzm/newrelic-grape
[3]: https://github.com/seanmoon/grape-librato
