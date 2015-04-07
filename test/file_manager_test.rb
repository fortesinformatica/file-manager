require './test/test_helper'
require 'memory_file_manager'

module FileManagerTest
  def test_reading
    assert_nil @manager.read_file 'not_saved'

    @manager.save_file 'saved', 'content'
    assert_equal 'content', @manager.read_file('saved')

    @manager.delete_file 'saved'
    assert_nil @manager.read_file 'saved'
  end

  def test_listing_files
    assert_empty @manager.list_files

    @manager.save_file 'saved.*', 'content'
    assert_equal [], @manager.list_files('other_prefix')
    assert_equal [], @manager.list_files('sav', 'other_ext')
    assert_equal ['saved.*'], @manager.list_files
    assert_equal ['saved.*'], @manager.list_files('sav')

    @manager.delete_file 'saved.*'
    assert_empty @manager.list_files
  end
end
