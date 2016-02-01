class AddJiveOauthTokens010Migration < ActiveRecord::Migration
	def self.up
		create_table :jive_oauth_tokens do |t|
			t.string :owner_id
			t.integer :owner_type

			t.string :scope
			t.string :token_type
			t.integer :expires_in
			t.timestamp :expires_at
			t.string :refresh_token
			t.string :access_token

			t.timestamps null: false
		end
	end

	def self.down
		drop_table :jive_oauth_tokens
	end
end