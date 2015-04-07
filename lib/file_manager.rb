class FileManager

  attr_accessor :options

  def initialize options
    @options = options
    @logger  = FileManager::Logger.new options
  end

  def read_file file_name
    raise 'Not implemented!'
  end

  def save_file(file_name, file_contents, write_options = {})
    raise 'Not implemented!'
  end

  def list_files(prefix = '', file_extension = '*')
    raise 'Not implemented!'
  end

  def delete_file file_name
    raise 'Not implemented!'
  end

  class Logger

    def initialize options
      @options = options
    end

    def print(text)
      super text unless @options[:silent]
    end

    def puts(text)
      super text unless @options[:silent]
    end
  end

end
