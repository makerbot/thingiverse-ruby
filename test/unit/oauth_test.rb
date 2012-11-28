require File.dirname(__FILE__) + '/../test_helper'
require "test/unit"
require "thingiverse"

class OAUTHTest < Test::Unit::TestCase

  def setup
    @thingiverse = Thingiverse::Connection.new('d1039c7beaa77f69aa6d', 'a24ab8620ad63fbc99794242f7e08aa0')
    @thingiverse.auth_url = 'http://thingiverse.dev:8888/login/oauth/access_token'
    @thingiverse.base_url = 'http://api.thingiverse.dev:8888'
  end
	
  # def test_get_token
  #     # hard to test a temp code :(
  #     @thingiverse.code = 'temp_code'
  #     access_token = @thingiverse.get_token
  #     
  #     assert_not_nil access_token
  #   assert_not_nil @thingiverse.access_token
  # 
  #     result = @thingiverse.newest
  # 
  #   assert_not_nil result
  # end

  def test_set_token
    @thingiverse.access_token = 'c7ed8686c1686e23305cc6ea24c72497';
    
    result = @thingiverse.things.newest
    # puts result.first.name

	  assert_not_nil result
	  assert result.size > 0
  end

end