class LocalFileManager

  attr_accessor :options

  def initialize options
    @options = options
  end

  def read_file file_name
    root_path = options[:root_path]
    print "Reading file \"#{file_name}\" from local folder \"#{root_path}\"..."
    contents = File.open("#{root_path}/#{file_name}", 'r:UTF-8') { |f| f.read }
    puts 'done.'

    contents
  end

  def save_file file_name, file_contents
    root_path = options[:root_path]
    print "Saving file \"#{file_name}\" to local folder \"#{root_path}\"..."
    File.open("#{root_path}/#{file_name}", 'wb') { |f| f.write(file_contents) }
    puts 'done.'
  end
end
