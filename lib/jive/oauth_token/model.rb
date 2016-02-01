module Jive
	module OauthToken
		class Model < ActiveRecord::Base
			self.table_name = :jive_oauth_tokens
			belongs_to :owner, :polymorphic => true
		end
	end
end