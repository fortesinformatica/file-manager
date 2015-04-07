require 'fileutils'
require 'file_manager'

class LocalFileManager < FileManager

  def read_file file_name
    root_path = options[:root_path]
    @logger.print "Reading file \"#{file_name}\" from local folder \"#{root_path}\"..."
    contents = File.open("#{root_path}/#{file_name}", 'r:UTF-8') { |f| f.read }
    @logger.puts 'done.'

    contents
  end

  def save_file(file_name, file_contents, write_options = {})
    root_path = options[:root_path]
    FileUtils.mkdir_p(root_path)
    @logger.print "Saving file \"#{file_name}\" to local folder \"#{root_path}\"..."
    File.open("#{root_path}/#{file_name}", 'wb') { |f| f.write(file_contents) }
    @logger.puts 'done.'
  end

  def list_files(prefix = '', file_extension = '*')
    root_path = options[:root_path]
    FileUtils.mkdir_p(root_path)
    @logger.print "Listing \"#{prefix}*.#{file_extension}\" from local folder \"#{root_path}\"..."
    files = Dir["#{root_path}/#{prefix}*.#{file_extension}"].map{|f| File.basename(f)}
    @logger.puts 'done.'
    files
  end

  def delete_file file_name
    root_path = options[:root_path]
    @logger.print "Deleting file \"#{file_name}\" from local folder \"#{root_path}\"..."
    File.delete("#{root_path}/#{file_name}")
    @logger.puts 'done.'
  end
end
