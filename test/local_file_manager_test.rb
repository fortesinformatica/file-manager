require './test/test_helper'
require 'local_file_manager'

SingleCov.covered!

class LocalFileManagerTest < Minitest::Test
  include FileManagerTest

  def setup
    @manager = LocalFileManager.new({root_path: Dir.mktmpdir + '/root_path/', silent: true})
  end

end
