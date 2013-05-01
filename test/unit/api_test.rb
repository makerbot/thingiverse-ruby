require File.dirname(__FILE__) + '/../test_helper'
require "test/unit"
require "thingiverse"
require 'tempfile'

class APITest < Test::Unit::TestCase

  def setup
    @thingiverse = Thingiverse::Connection.new(THINGIVERSE_CLIENT_ID, THINGIVERSE_SECRET)
    @thingiverse.auth_url = THINGIVERSE_AUTH_URL
    @thingiverse.base_url = THINGIVERSE_BASE_URL
    @thingiverse.access_token = THINGIVERSE_ACCESS_TOKEN
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
    assert user.full_name == 'Tony Buser'
  end
  
  def test_user_me
    user = @thingiverse.users.find('me')
  
    assert user.name == 'tbuser'
  end
  
  def test_user_name
    user = @thingiverse.users.find('bre')
  
    assert user.location == 'Brooklyn'
  end
  
  def test_thing_images
    thing = @thingiverse.things.find(17508)
    images = thing.images
  
    assert images.size > 0
    # TODO: make this more easily selectable!  Also: how do you select images for a file??
    # puts images[0].sizes.select {|f| f["type"] == "display" and f["size"] == "small" }[0].inspect
    # puts images[0].sizes.select {|f| f["type"] == "display" and f["size"] == "small" }[0]["url"]
  end
  
  def test_create_thing
    thing = @thingiverse.things.create(:name => 'Create Test Thing', :license => 'cc-sa', :category => 'other', :description => 'foo bar', :is_wip => true)
  
    assert thing.id.to_s != ''
    assert thing.added.to_s != ''
  end
  
  def test_save_new_thing
    thing = @thingiverse.things.new(:name => 'Create Test Thing', :license => 'cc-sa', :category => 'other', :description => 'foo bar', :is_wip => true)
    thing.name = 'Foo Bar'
    thing.save
  
    assert thing.id.to_s != ''
    assert thing.added.to_s != ''
  end
  
  def test_update_thing
    thing = @thingiverse.things.create(:name => 'Test Thing', :license => 'cc-sa', :category => 'other', :description => 'foo bar', :is_wip => true)
    
    thing.name = "Update Test Thing"
    thing.save
    date_before = thing.modified
  
    sleep(5)
  
    thing.name = "Updated Test Thing"
    thing.save
    date_after = thing.modified
    
    assert date_after > date_before
  end
  
  def test_file_upload_with_file_object_default_name
    thing = @thingiverse.things.create(:name => 'Create Test Thing With File', :license => 'cc-sa', :category => 'other', :description => 'foo bar', :is_wip => true)
    # thing = @thingiverse.things.find(29387)
    file = thing.upload(File.open(File.dirname(__FILE__) + '/../fixtures/test.stl'))
  
    # puts file.url
    assert file.name == 'test.stl'
  end
  
  def test_file_upload_with_file_object_explicit_name
    thing = @thingiverse.things.create(:name => 'Create Test Thing With File', :license => 'cc-sa', :category => 'other', :description => 'foo bar', :is_wip => true)
    # thing = @thingiverse.things.find(29387)
    file = thing.upload(File.open(File.dirname(__FILE__) + '/../fixtures/test.stl'), 'my.stl')
  
    # puts file.url
    assert file.name == 'my.stl'
  end
  
  def test_file_upload_with_string_object
    thing = @thingiverse.things.create(:name => 'Create Test Thing With File From String', :license => 'cc-sa', :category => 'other', :description => 'foo bar', :is_wip => true)
    file_content = File.open(File.dirname(__FILE__) + '/../fixtures/test.stl', 'rb') { |f| f.read } # load content from file into string
    thingiverse_filename = "myfile.stl"
    file = thing.upload(file_content, thingiverse_filename)
  
    #puts file.url
    assert file.name == 'myfile.stl'
  end
  
  # a few test cases for bad param usage.
  def test_file_upload_wrong_params
    assert_raise ArgumentError do Thingiverse::Things.new.upload(nil, nil) end # nil as file
    assert_raise ArgumentError do Thingiverse::Things.new.upload(4, nil) end # wrong type as file
    assert_raise ArgumentError do Thingiverse::Things.new.upload("content", nil) end # no thingiverse filename for string file
  end
  
  def test_upload_binary_stl
    thing = @thingiverse.things.new(:name => 'Binary Create Test Thing', :license => 'cc-sa', :category => 'other', :description => 'foo bar', :is_wip => true)
    thing.save
  
    thing.upload(File.open(File.dirname(__FILE__) + '/../fixtures/binary.stl'))
  
    thing.publish
  
    assert thing.is_published
  end
  
  def test_upload_tempfile
    thing = @thingiverse.things.new(:name => 'Tempfile Create Test Thing', :license => 'cc-sa', :category => 'other', :description => 'foo bar', :is_wip => true)
    thing.save
  
    tempfile = Tempfile.new('foo')
    tempfile.write('bar')
    tempfile.close
  
    file = thing.upload(tempfile)
  
    tempfile.unlink
  
    assert file.name.to_s != ""
  end
  
  def test_publish_new_thing
    thing = @thingiverse.things.new(:name => 'Create Test Thing', :license => 'cc-sa', :category => 'other', :description => 'foo bar', :is_wip => true)
    thing.save
  
    thing.upload(File.open(File.dirname(__FILE__) + '/../fixtures/test.stl'))
  
    thing.publish
  
    assert thing.is_published
  end
  
  def test_thing_category
    thing = @thingiverse.things.find(27091)
  
    assert thing.categories[0].name == "Scans & Replicas"
  end
  
  def test_set_ancestors
    thing = @thingiverse.things.new(
      :name => 'Test Thing With Ancestors',
      :license => 'cc-sa',
      :category => 'other',
      :description => 'foo bar',
      :is_wip => true,
      :ancestors => [27091, 29387]
    )
    thing.save
  
    assert thing.ancestors.size == 2
  end
  
  def test_set_tags
    thing = @thingiverse.things.new(
      :name => 'Test Thing With Tags',
      :license => 'cc-sa',
      :category => 'other',
      :description => 'foo bar',
      :is_wip => true,
      :tags => ["foo", "bar", "baz"]
    )
    thing.save
  
    assert thing.tags.size == 3
  end
  
  def test_tag_thing_list
    tag = @thingiverse.tags.find("doctor_who")
    things = tag.things
  
    assert tag.count > 42
    assert things.size > 1
  end
  
  def test_pagination
    tag = @thingiverse.tags.find("123dcatch")
    assert tag.count > 30
  
    things = tag.things
    # puts things.current_page
    # puts things.total_pages
    # puts things.first_url
    # puts things.prev_url
    # puts things.next_url
    # puts things.last_url
    # puts things.next_page.inspect
    assert things.current_page == 1
    assert things.total_pages > 1
    assert things.next_url.include?("page=2")
  
    more_things = things.next_page
    assert more_things.current_page == 2
    assert more_things.last_url.include?("123dcatch")
  
    second_page = tag.things(:page => 2)
    assert more_things.first.name == second_page.first.name
  end
  
  def test_newest
    newest_things = @thingiverse.things.newest
    assert newest_things.first.name.size > 0
    assert newest_things.total_pages > 0
  end
  
  def test_pagination_per_page
    tag = @thingiverse.tags.find("reprap")
    things = tag.things(:per_page => 8)
    assert things.total_pages > 8
  end
  
  def test_dynamic_attributes
    user = @thingiverse.users.find('me')
    assert user.name == 'tbuser'
  
    user.name = 'foo'
    assert user.name == 'foo'
    assert user.attributes['name'] == 'foo'
  
    user.foo = 'bar'
    assert user.foo == 'bar'
    assert user.attributes['foo'] == 'bar'
  end
end
