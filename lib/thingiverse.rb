#!/usr/bin/env ruby -wKU

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

require 'rubygems'
require 'json'
require 'httparty'

class Thingiverse
  include HTTParty

  VERSION = '0.0.1'
  attr_accessor :client_id, :client_secret, :code, :access_token, :auth_url, :base_url
  
  def initialize(client_id = nil, client_secret = nil, code = nil)
    @client_id      = client_id
    @client_secret  = client_secret
    @code           = code
    
    self.class.base_uri(self.base_url)
    
    self.get_token if @client_id and @client_secret and @code
  end

  def auth_url
    @auth_url || 'http://www.thingiverse.com/login/oauth/access_token'
  end

  def base_url=(url)
    @base_url = url
    self.class.base_uri(url)
  end

  def base_url
    @base_url || 'https://api.thingiverse.com'
  end

  def get_token
    auth_response = self.class.post(@auth_url, {:client_id => @client_id, :client_secret => @client_secret, :code => @code})

    @access_token = auth_response['access_token']

    @access_token
  end

  def newest
    self.class.get('/newest', :headers => {"Authorization" => "Bearer " + @access_token})
  end
  
end