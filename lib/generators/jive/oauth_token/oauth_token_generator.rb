require 'rails/generators/base'
require 'jive/oauth_token/compatibility'

module Jive
	class OauthToken < ActiveRecord::Base
		class Generator < Rails::Generators::Base
			source_paths << File.join(File.dirname(__FILE__), 'templates')
		end
	end
end

