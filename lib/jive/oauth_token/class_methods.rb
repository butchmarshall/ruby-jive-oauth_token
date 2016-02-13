module Jive
	class OauthToken < ActiveRecord::Base
		module ClassMethods
			def self.extended(base)
				base.belongs_to :owner, :polymorphic => true
			end
		end
	end
end