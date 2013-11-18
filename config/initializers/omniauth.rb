Rails.application.config.middleware.use OmniAuth::Builder do
	require_relative './auth_secrets'

  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :gplus, ENV['GPLUS_KEY'], ENV['GPLUS_SECRET'],
  				 scope: 'plus.login'
end