require 'spec_helper'

describe Jive::OauthToken do
	# Setup add-on
	before(:each) do
		stub_request(:post, "https://market.apps.jivesoftware.com/appsmarket/services/rest/jive/instance/validation/8ce5c231-fab8-46b1-b8b2-fc65deccbb5d").
         with(:body => "clientId:2zm4rzr9aiuvd4zhhg8kyfep229p2gce.i\nclientSecret:09da4b6f11102012b476a686fabb37a61240ba89477f0fec4d0f974b428dd141\njiveSignatureURL:https://market.apps.jivesoftware.com/appsmarket/services/rest/jive/instance/validation/8ce5c231-fab8-46b1-b8b2-fc65deccbb5d\njiveUrl:https://sandbox.jiveon.com\ntenantId:b22e3911-28ef-480c-ae3b-ca791ba86952\ntimestamp:2015-11-20T16:04:55.895+0000\n",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Jive-Mac'=>'0YqbK1nW+L+j3ppE7PHo3CvM/pNyHIDbNwYYvkKJGXU='}).                                                                                           
         to_return(:status => 200, :body => "", :headers => {})

		@add_on = ::Jive::AddOn.create({
			client_id: '2zm4rzr9aiuvd4zhhg8kyfep229p2gce.i',
			tenant_id: 'b22e3911-28ef-480c-ae3b-ca791ba86952',
			jive_signature_url: 'https://market.apps.jivesoftware.com/appsmarket/services/rest/jive/instance/validation/8ce5c231-fab8-46b1-b8b2-fc65deccbb5d',
			client_secret: 'evaqjrbfyu70jlvnap8fhnj2h5mr4vus.s',
			jive_signature: '0YqbK1nW+L+j3ppE7PHo3CvM/pNyHIDbNwYYvkKJGXU=',
			jive_url: 'https://sandbox.jiveon.com',
			timestamp: '2015-11-20T16:04:55.895+0000',
		})
	end

	it 'has a version number' do
		expect(Jive::OauthToken::VERSION).not_to be nil
	end

	describe "#refresh_access_token" do
		it 'should fetch a refreshed access token from the server' do
			stub_request(:post, "https://2zm4rzr9aiuvd4zhhg8kyfep229p2gce.i:evaqjrbfyu70jlvnap8fhnj2h5mr4vus.s@sandbox.jiveon.com/oauth2/token").
			with(:body => {"grant_type"=>"refresh_token", "refresh_token"=>"iwi8t496x7njd2hiwlxxwwmrih7bumjsvbontai5.r"},
				 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
			to_return(:status => 200, :body => '{"access_token":"eqiim383ec92gtosqru7wuvl8jl2tm1cawje3o4f.t","refresh_token":"iwi8t496x7njd2hiwlxxwwmrih7bumjsvbontai5.r","token_type":"bearer","expires_in":"172799"}', :headers => {})

			expires_at = Time.now + 10.days

			@oauth_token = Jive::OauthToken.create(
				:add_on => @add_on,
				:scope => "uri:/api/jivelinks/v1/tiles/10543",
				:token_type => "bearer",
				:expires_in => "172799",
				:expires_at => expires_at,
				:refresh_token => "iwi8t496x7njd2hiwlxxwwmrih7bumjsvbontai5.r",
				:access_token => "a3fxey31tdc7o3ctwvgn8vflgxurt9j8lmovgf2q.t",
			)
			@oauth_token.refresh_access_token

			expect(@oauth_token.access_token).to eq "eqiim383ec92gtosqru7wuvl8jl2tm1cawje3o4f.t"
		end
		it 'should raise exception returned from jive' do
			stub_request(:post, "https://2zm4rzr9aiuvd4zhhg8kyfep229p2gce.i:evaqjrbfyu70jlvnap8fhnj2h5mr4vus.s@sandbox.jiveon.com/oauth2/token").
			with(:body => {"grant_type"=>"refresh_token", "refresh_token"=>"iwi8t496x7njd2hiwlxxwwmrih7bumjsvbontai5.r"},
				 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
			to_return(:status => 400, :body => '{"error":"invalid_grant","error_description":"Bad refresh token"}', :headers => {})

			expires_at = Time.now + 10.days

			@oauth_token = Jive::OauthToken.create(
				:add_on => @add_on,
				:scope => "uri:/api/jivelinks/v1/tiles/10543",
				:token_type => "bearer",
				:expires_in => "172799",
				:expires_at => expires_at,
				:refresh_token => "iwi8t496x7njd2hiwlxxwwmrih7bumjsvbontai5.r",
				:access_token => "a3fxey31tdc7o3ctwvgn8vflgxurt9j8lmovgf2q.t",
			)

			expect { @oauth_token.refresh_access_token }.to raise_error(RuntimeError, "INVALID_GRANT")
		end
	end

	describe "#access_token_expired?" do
		it 'should be true when expired' do
			expires_at = Time.now - 10.days

			@oauth_token = Jive::OauthToken.create(
				:add_on => @add_on,
				:scope => "uri:/api/jivelinks/v1/tiles/10543",
				:token_type => "bearer",
				:expires_in => "172799",
				:expires_at => expires_at,
				:refresh_token => "iwi8t496x7njd2hiwlxxwwmrih7bumjsvbontai5.r",
				:access_token => "a3fxey31tdc7o3ctwvgn8vflgxurt9j8lmovgf2q.t",
			)
			expect(@oauth_token.access_token_expired?).to eq true
		end
		it 'should be false when !expired' do
			expires_at = Time.now + 10.days

			@oauth_token = Jive::OauthToken.create(
				:add_on => @add_on,
				:scope => "uri:/api/jivelinks/v1/tiles/10543",
				:token_type => "bearer",
				:expires_in => "172799",
				:expires_at => expires_at,
				:refresh_token => "iwi8t496x7njd2hiwlxxwwmrih7bumjsvbontai5.r",
				:access_token => "a3fxey31tdc7o3ctwvgn8vflgxurt9j8lmovgf2q.t",
			)
			expect(@oauth_token.access_token_expired?).to eq false
		end
	end
end
