require './test/test_helper'
require 's3_file_manager'

class S3FileManagerTest < Minitest::Test
  include FileManagerTest

  FileManagerTest.instance_methods(false).each do |method|
    define_method(method) do
      VCR.use_cassette(method) do
        super()
      end
    end
  end

  def setup
    @manager = S3FileManager.new({bucket: 'file-manager-tests', silent: true})
  end

end
