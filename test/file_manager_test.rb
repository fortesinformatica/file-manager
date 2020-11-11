require './test/test_helper'
require 'memory_file_manager'

SingleCov.covered! uncovered: 5

module FileManagerTest
  def test_reading
    assert_raises(FileNotFoundError) { @manager.read_file 'not_saved' }

    @manager.save_file 'saved', 'content'
    assert_equal 'content', @manager.read_file('saved')

    @manager.delete_file 'saved'
    assert_raises(FileNotFoundError) { @manager.read_file 'saved' }
  end

  def test_reading_in_sub_dir
    assert_raises(FileNotFoundError) { @manager.read_file 'sub_dir/not_saved' }

    @manager.save_file 'sub_dir/saved', 'content'
    assert_equal 'content', @manager.read_file('sub_dir/saved')

    @manager.delete_file 'sub_dir/saved'
    assert_raises(FileNotFoundError) { @manager.read_file 'sub_dir/saved' }
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

  def test_listing_files_in_sub_dir
    assert_empty @manager.list_files

    @manager.save_file 'sub_dir/saved.*', 'content'
    assert_equal [], @manager.list_files('other_prefix')
    assert_equal [], @manager.list_files('sav', 'other_ext')
    assert_equal ['sub_dir/saved.*'], @manager.list_files
    assert_equal ['sub_dir/saved.*'], @manager.list_files('sub_dir/sav')
  ensure
    @manager.delete_file 'sub_dir/saved.*'
    assert_empty @manager.list_files
  end


  def test_remove_not_existing_file_dont_raise
    assert_empty @manager.list_files
    @manager.delete_file 'sub_dir/saved.*'
  end

  def test_downloading_to_temp_file
    @manager.save_file 'temp_file/saved', 'content'
    assert_equal 'content', @manager.read_file('temp_file/saved')

    @manager.download_to_temp_file('temp_file/saved') do |temp_file|
      contents = File.open(temp_file) { |f| f.read }
      assert_equal contents, 'content'
    end

    @manager.delete_file 'temp_file/saved'
  end

  def test_rename_file
    assert_empty @manager.list_files
    @manager.save_file 'original/name.txt', 'rename_content'

    @manager.rename_file 'original/name.txt', 'new/name.txt'
    assert_equal ['new/name.txt'], @manager.list_files
    assert_equal 'rename_content', @manager.read_file('new/name.txt')

    @manager.rename_file 'new/name.txt', 'new/new2/name.txt'
    assert_equal ['new/new2/name.txt'], @manager.list_files
    assert_equal 'rename_content', @manager.read_file('new/new2/name.txt')
  ensure
    @manager.delete_file 'original/name.txt'
    @manager.delete_file 'new/new2/name.txt'
    assert_empty @manager.list_files
  end
end

class FileManagerLoggerTest < Minitest::Test

  def test_logger_prints_and_puts
    logger = FileManager::Logger.new({})
    assert_output("hello\n") { logger.puts "hello" }
    assert_output("hi") { logger.print "hi" }
  end
end
