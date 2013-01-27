require File.dirname(__FILE__) + '/../test_helper'
require "test/unit"
require "thingiverse"

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
    thing = @thingiverse.things.find(29387)

    date_before = thing.modified

    thing.name = "furry foo bar"
    thing.save

    assert thing.modified > date_before
  end

  def test_file_upload
    thing = @thingiverse.things.create(:name => 'Create Test Thing With File', :license => 'cc-sa', :category => 'other', :description => 'foo bar', :is_wip => true)
    # thing = @thingiverse.things.find(29387)
    file = thing.upload(File.open(File.dirname(__FILE__) + '/../fixtures/test.stl'))

    # puts file.url
    assert file.name == 'test.stl'
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

    assert thing.ancestor_things.size == 2
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

    assert thing.tag_records.size == 3
  end
end
