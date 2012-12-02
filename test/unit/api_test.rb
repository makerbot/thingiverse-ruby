require File.dirname(__FILE__) + '/../test_helper'
require "test/unit"
require "thingiverse"

class APITest < Test::Unit::TestCase

  def setup
    @thingiverse = Thingiverse::Connection.new('d1039c7beaa77f69aa6d', 'a24ab8620ad63fbc99794242f7e08aa0')
    @thingiverse.auth_url = 'http://thingiverse.dev:8888/login/oauth/access_token'
    @thingiverse.base_url = 'http://api.thingiverse.dev:8888'
    @thingiverse.access_token = 'c7ed8686c1686e23305cc6ea24c72497';
  end
	
  def test_get_thing
    thing = @thingiverse.things.find(17508)

    assert thing.name == "Ring-A-Thing w/ Pin Connectors"
  end

  def test_thing_files
    thing = @thingiverse.things.find(17508)
    files = thing.files

    assert files.size > 0
  end

  def test_thing_user
    thing = @thingiverse.things.find(17508)
    user = thing.user
    
    assert user.name == 'tbuser'
  end

  def test_user_me
    user = @thingiverse.users.find('me')

    assert user.name == 'tbuser'
  end

  def test_user_name
    user = @thingiverse.users.find('bre')

    assert user.location == 'Brooklyn'
  end

end