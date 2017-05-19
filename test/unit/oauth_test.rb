require File.dirname(__FILE__) + '/../test_helper'
require "test/unit"
require "thingiverse"

class OAUTHTest < Test::Unit::TestCase

  def setup
    @thingiverse = Thingiverse::Connection.new(THINGIVERSE_CLIENT_ID, THINGIVERSE_SECRET)
    @thingiverse.auth_url = THINGIVERSE_AUTH_URL
    @thingiverse.base_url = THINGIVERSE_BASE_URL
  end

  # def test_get_token
  #   # hard to test a temp code :(
  #   @thingiverse.code = 'foo'
  #   access_token = @thingiverse.get_token
  # 
  #   assert_not_nil access_token
  #   assert @thingiverse.access_token.size > 0
  # 
  #   result = @thingiverse.things.newest
  # 
  #   assert_not_nil result
  # end
  
  def test_set_token
    @thingiverse.access_token = THINGIVERSE_ACCESS_TOKEN
  
    result = @thingiverse.things.newest
    # puts result.first.name
  
    assert_not_nil result
    assert result.size > 0
  end

end
