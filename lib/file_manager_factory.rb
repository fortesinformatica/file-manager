require 's3_file_manager'
require 'local_file_manager'
require 'memory_file_manager'

class FileManagerFactory
  FILE_MANAGERS = {
      'S3'     => ::S3FileManager,
      'local'  => ::LocalFileManager,
      'memory' => ::MemoryFileManager
  }

  def initialize(file_managers_config)
    @file_managers_config = file_managers_config
  end

  def create(name)
    config = @file_managers_config[name]
    FILE_MANAGERS[config[:type]].new config
  end
end
