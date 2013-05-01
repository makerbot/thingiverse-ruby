$: << File.dirname(File.expand_path(__FILE__))+'/../lib'

THINGIVERSE_CLIENT_ID    = ENV.fetch('THINGIVERSE_CLIENT_ID','6806845037e641ebaf75')
THINGIVERSE_SECRET       = ENV.fetch('THINGIVERSE_SECRET','275908d8c6fa29900fd73199b1cea3b2')
THINGIVERSE_ACCESS_TOKEN = ENV.fetch('THINGIVERSE_ACCESS_TOKEN','d522b2638d92145e46bd6baf17555ca3')

THINGIVERSE_AUTH_URL     = ENV.fetch('THINGIVERSE_AUTH_URL','http://thingiverse.dev:8888/login/oauth/access_token')

THINGIVERSE_BASE_URL     = ENV.fetch('THINGIVERSE_BASE_URL','http://api.thingiverse.dev:8888')
