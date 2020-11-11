require 'file_manager'

class MemoryFileManager < FileManager

  def initialize(options)
    super
    @data = {}
  end

  def read_file file_name
    @data["#{file_name}"] || (raise FileNotFoundError.new("No such file '#{file_name}'"))
  end

  def save_file(file_name, file_contents, write_options = {})
    @data["#{file_name}"] = file_contents.to_s
  end

  def list_files(prefix = '', file_extension = '*')
    if prefix == '' && file_extension == '*'
      return @data.keys
    end

    @data.keys.select{|key| key.start_with?(prefix) && key.end_with?(".#{file_extension}")}
  end

  def delete_file file_name
    @data.delete "#{file_name}"
  end

  def download_to_temp_file(file_name)
    Dir.mktmpdir do |dir|
      temp_file = "#{dir}/#{Pathname(file_name).basename}"
      content = read_file(file_name)
      File.open(temp_file, 'w') { |file| file.write(content) }
      yield(temp_file)
    end
  end

  def rename_file original_file_name, target_file_name
    @data["#{target_file_name}"] = @data["#{original_file_name}"]
    @data.delete "#{original_file_name}"
  end
end
