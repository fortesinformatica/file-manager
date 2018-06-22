require './test/test_helper'
SingleCov.not_covered! # not testing any code in lib/

class CoverageTest < Minitest::Test
  def test_for_untested_code
    # option :tests to pass custom Dir.glob results
    SingleCov.assert_used
  end

  def test_for_untested_files
    # option :tests and :files to pass custom Dir.glob results
    # :untested to get it passing with known untested files
    SingleCov.assert_tested untested: %w[lib/file_manager_factory.rb]
  end
end
