require 'pathname'
require 'fileutils'
require 'file_manager'

class LocalFileManager < FileManager

  def read_file file_name
    @logger.print "Reading file \"#{file_name}\" from local folder \"#{root_path}\"..."
    full_file_name = File.join(root_path, file_name)
    contents = File.open(full_file_name, 'r:UTF-8') { |f| f.read }
    @logger.puts 'done.'

    contents
  rescue Errno::ENOENT
    raise FileNotFoundError.new(full_file_name)
  end

  def save_file(file_name, file_contents, write_options = {})
    @logger.print "Saving file \"#{file_name}\" to local folder \"#{root_path}\"..."
    full_file_name = Pathname(File.join(root_path, file_name))
    FileUtils.mkdir_p(full_file_name.dirname)
    File.open(full_file_name, 'wb') { |f| f.write(file_contents) }
    @logger.puts 'done.'
  end

  def download_to_temp_file(file_name)
    @logger.print "Copying local file \"#{file_name}\" to folder \"#{root_path}\"..."
    full_file_name = Pathname(File.join(root_path, file_name))
    Dir.mktmpdir do |dir|
      temp_file = "#{dir}/#{full_file_name.basename}"
      FileUtils.cp(full_file_name, temp_file)
      yield(temp_file)
    end
    @logger.puts 'done.'
  end

  def list_files(prefix = '', file_extension = '*')
    FileUtils.mkdir_p(root_path)
    @logger.print "Listing \"#{prefix}*.#{file_extension}\" from local folder \"#{root_path}\"..."
    files = Dir[File.join(root_path, '**', prefix, "*.#{file_extension}"),
                File.join(root_path, "#{prefix}*.#{file_extension}")].map do |f|
      f[root_path.size..-1]
    end.uniq
    @logger.puts 'done.'
    files
  end

  def delete_file file_name
    @logger.print "Deleting file \"#{file_name}\" from local folder \"#{root_path}\"..."
    full_file_name = File.join(root_path, file_name)
    File.delete(full_file_name) if File.exist?(full_file_name)
    @logger.puts 'done.'
  end

  def rename_file original_file_name, target_file_name
    @logger.print "Renaming file \"#{original_file_name}\" to \"#{target_file_name}\" from local folder \"#{root_path}\"..."
    full_original_file_name = File.join(root_path, original_file_name)
    full_target_file_name = Pathname(File.join(root_path, target_file_name))
    FileUtils.mkdir_p(full_target_file_name.dirname)
    FileUtils.mv full_original_file_name, full_target_file_name
    @logger.puts 'done.'
  end

  private

  def root_path
    options.fetch(:root_path)
  end

end
