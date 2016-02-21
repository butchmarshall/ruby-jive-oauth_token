require "active_support"
require "active_support/dependencies"
require "active_record"

require "jive/add_on"
require "jive/oauth_token/add_on/class_methods"

require "jive/oauth_token/version"
require "jive/oauth_token/compatibility"

require "jive/oauth_token/class_methods"
require "jive/oauth_token/instance_methods"

module Jive
	class OauthToken < ActiveRecord::Base
	end
end

Jive::OauthToken.send :include, Jive::OauthToken::InstanceMethods
Jive::OauthToken.send :extend, Jive::OauthToken::ClassMethods

# We want add-ons to know they can now associate with OAuthTokens
Jive::AddOn.send :include, Jive::OauthToken::AddOn::ClassMethods