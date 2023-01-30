require File.expand_path("../lib/thingiverse/version", __FILE__)

Gem::Specification.new do |s|
  s.name              = "thingiverse"
  s.rubyforge_project = "thingiverse"

  s.version           = Thingiverse::VERSION
  s.platform          = Gem::Platform::RUBY

  s.summary           = "Thingiverse API"
  s.description       = "Thingiverse API"
  s.authors           = ["Tony Buser"]
  s.email             = 'tony@makerbot.com'
  s.homepage          = 'http://github.com/makerbot/thingiverse-ruby'

  s.require_paths     = ["lib"]
  s.files             = Dir["{lib}/**/*.rb", "test/*", "LICENSE", "README.rdoc"]

  s.add_dependency("json")
  s.add_dependency("httparty")
  s.add_dependency("curb")
end
