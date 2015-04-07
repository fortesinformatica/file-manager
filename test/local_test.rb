require './test/test_helper'
require 'local_file_manager'

class LocalFileManagerTest < Minitest::Test
  include FileManagerTest

  def setup
    @manager = LocalFileManager.new({root_path: Dir.mktmpdir})
  end

end
