module Jive
	class OauthToken < ActiveRecord::Base
		module AddOn
			module ClassMethods
				def self.included(base)
					base.class_eval do
						has_many :oauth_tokens, :class_name => "Jive::OauthToken", :as => :owner
					end
				end
			end
		end
	end
end
