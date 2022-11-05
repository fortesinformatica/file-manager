require './test/test_helper'
require 'memory_file_manager'
require_relative 'file_manager_test'

SingleCov.covered!

class MemoryFileManagerTest < Minitest::Test
  include FileManagerTest

  def setup
    @manager = MemoryFileManager.new({})
  end

  private

  def read(file_name)
    @manager.read_file(file_name)
  end
end
