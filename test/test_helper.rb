$: << File.dirname(File.expand_path(__FILE__))+'/../lib'

THINGIVERSE_CLIENT_ID    = ENV.fetch('THINGIVERSE_CLIENT_ID','d987ff07e75964e80e41')
THINGIVERSE_SECRET       = ENV.fetch('THINGIVERSE_SECRET','8cbb6ce48539fb27af9df4c6b7f114ba')
THINGIVERSE_ACCESS_TOKEN = ENV.fetch('THINGIVERSE_ACCESS_TOKEN','ff15792d7bcbd3e5453cad7f83fb3acf')
THINGIVERSE_AUTH_URL     = ENV.fetch('THINGIVERSE_AUTH_URL','https://thingiverse.dev/login/oauth/access_token')
THINGIVERSE_BASE_URL     = ENV.fetch('THINGIVERSE_BASE_URL','https://api.thingiverse.dev')
