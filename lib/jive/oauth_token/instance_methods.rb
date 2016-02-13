module Jive
	class OauthToken < ActiveRecord::Base
		module InstanceMethods
			def self.included(base)
				base.table_name = "jive_oauth_tokens"
			end
		end
	end
end