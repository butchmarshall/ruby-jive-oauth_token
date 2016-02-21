module Jive
	class OauthToken < ActiveRecord::Base
		module InstanceMethods
			def self.included(base)
				base.table_name = "jive_oauth_tokens"
			end

			# Gets a valid access token from this object - Will refresh existing token if invalid
			def valid_access_token
				# The token we have stored is expired - fetch a new one using the refresh token
				self.refresh_access_token if self.access_token_expired?

				self.access_token
			end

			# Fetches a refreshed access token
			def refresh_access_token
				require "open-uri"
				require "net/http"
				require "openssl"
				require "base64"

				uri = URI.parse("#{self.add_on.jive_url}/oauth2/token")
				http = Net::HTTP.new(uri.host, uri.port)
				http.use_ssl = true

				request = Net::HTTP::Post.new(uri.request_uri)
				request.basic_auth self.add_on.client_id, self.add_on.client_secret
				request.set_form_data({
					"refresh_token" => "#{self.refresh_token}",
					"grant_type" => "refresh_token",
				})

				response = http.request(request)
				json_body = JSON.parse(response.body)

				if (response.code.to_i != 200)
					raise RuntimeError, json_body["error"].to_s.upcase
				end

				self.access_token = json_body["access_token"]
				self.expires_in = json_body["expires_in"]
				self.expires_at = json_body["expires_in"].to_i.seconds.from_now
				self.save
			end

			# Return whether access token is expired
			def access_token_expired?
				return false if self.expires_at.nil?

				# Expiration date less than now == expired
				self.expires_at < Time.now
			end
		end
	end
end