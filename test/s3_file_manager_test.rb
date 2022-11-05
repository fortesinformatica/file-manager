require './test/test_helper'
require 's3_file_manager'

SingleCov.covered!

class S3FileManagerTest < Minitest::Test
  include FileManagerTest

  FileManagerTest.instance_methods(false).each do |method|
    next if method == :test_obtain_url_of

    define_method(method) do
      VCR.use_cassette(method) do
        super()
      end
    end
  end

  def setup
    @manager = S3FileManager.new(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: 'us-west-2',
        bucket: 'file-manager-tests',
        silent: true
    )
  end

  private

  def read(url)
    Net::HTTP.get(URI(url))
  end
end
