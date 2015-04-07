require './test/test_helper'
require 'memory_file_manager'

class MemoryFileManagerTest < Minitest::Test
  include FileManagerTest

  def setup
    @manager = MemoryFileManager.new({})
  end

end
