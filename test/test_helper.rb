$: << File.dirname(File.expand_path(__FILE__))+'/../lib'

THINGIVERSE_CLIENT_ID    = ENV.fetch('THINGIVERSE_CLIENT_ID','')
THINGIVERSE_SECRET       = ENV.fetch('THINGIVERSE_SECRET','')
THINGIVERSE_ACCESS_TOKEN = ENV.fetch('THINGIVERSE_ACCESS_TOKEN','')

THINGIVERSE_AUTH_URL     = ENV.fetch('THINGIVERSE_AUTH_URL','http://www.thingiverse.com/login/oauth/access_token')

THINGIVERSE_BASE_URL     = ENV.fetch('THINGIVERSE_BASE_URL','http://api.thingiverse.com')
