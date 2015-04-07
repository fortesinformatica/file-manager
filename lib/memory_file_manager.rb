require 'file_manager'

class MemoryFileManager < FileManager

  def initialize(options)
    super
    @data = {}
  end

  def read_file file_name
    @data["#{file_name}"]
  end

  def save_file(file_name, file_contents, write_options = {})
    @data["#{file_name}"] = file_contents.to_s
  end

  def list_files(prefix = '', file_extension = '*')
    @data.keys.select{|key| key.start_with?(prefix) && key.end_with?(".#{file_extension}")}
  end

  def delete_file file_name
    @data.delete "#{file_name}"
  end

end
