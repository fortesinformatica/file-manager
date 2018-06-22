require './test/test_helper'
require 'memory_file_manager'

SingleCov.covered!

class MemoryFileManagerTest < Minitest::Test
  include FileManagerTest

  def setup
    @manager = MemoryFileManager.new({})
  end

end
