module Jive
	class OauthToken < ActiveRecord::Base
		module ClassMethods
			def self.extended(base)
				base.belongs_to :owner, :polymorphic => true
				base.belongs_to :add_on, :class_name => "Jive::AddOn", :foreign_key => :jive_add_on_id
				base.validates :add_on, presence: true
			end
		end
	end
end