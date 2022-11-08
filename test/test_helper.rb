require 'single_cov'
SingleCov.setup :minitest, branches: true if RUBY_PLATFORM != "java"
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock
  # c.debug_logger = File.open("record.log", 'w')
end
