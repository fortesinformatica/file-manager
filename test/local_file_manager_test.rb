require './test/test_helper'
require 'local_file_manager'
require_relative 'file_manager_test'

SingleCov.covered!

class LocalFileManagerTest < Minitest::Test
  include FileManagerTest

  def setup
    @manager = LocalFileManager.new({root_path: Dir.mktmpdir + '/root_path/', silent: true})
  end
end
