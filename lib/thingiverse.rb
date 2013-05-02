require 'rubygems'
require 'json'
require 'httparty'
require 'curb'
require 'cgi'
require 'uri'

require 'thingiverse/dynamic_attributes'
require 'thingiverse/connection'
require 'thingiverse/pagination'
require 'thingiverse/things'
require 'thingiverse/files'
require 'thingiverse/users'
require 'thingiverse/images'
require 'thingiverse/categories'
require 'thingiverse/tags'

module Thingiverse
  VERSION = '0.0.7'
end
