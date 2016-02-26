[![Gem Version](https://badge.fury.io/rb/jive-oauth_token.svg)](http://badge.fury.io/rb/jive-oauth_token)
[![Build Status](https://travis-ci.org/butchmarshall/ruby-jive-oauth_token.svg?branch=master)](https://travis-ci.org/butchmarshall/ruby-jive-oauth_token)

# Jive::OauthToken

An implemention of Jives Oauth Tokens using ActiveRecord.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jive-oauth_token'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jive-oauth_token

then run

```ruby
rails generate jive:oauth_token:active_record
```

## Usage

To the ActiveRecord model:

```ruby
Jive::OauthToken.new(...)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/butchmarshall/ruby-jive-oauth_token.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

