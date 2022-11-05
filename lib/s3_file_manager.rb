require 'file_manager'
require 'aws-sdk-s3'

class S3FileManager < FileManager

  def read_file file_name
    s3_service = connect_s3_service
    bucket = s3_service.bucket(bucket_name)

    logger.print "Reading file \"#{file_name}\" from bucket \"#{bucket_name}\"..."
    contents = bucket.object(file_name).get.body.read
    logger.puts 'done.'

    contents
  rescue Aws::S3::Errors::NoSuchKey
    raise FileNotFoundError.new("#{bucket_name}/#{file_name}")
  end

  def bucket_name
    options.fetch(:bucket)
  end

  def save_file(file_name, file_contents, write_options = {})
    logger.print "Saving file \"#{file_name}\" to bucket \"#{bucket_name}\"..."
    s3_service = connect_s3_service
    bucket = s3_service.bucket(bucket_name)

    obj = bucket.object(file_name)
    obj.put(write_options.merge(body: file_contents.to_s))
    logger.puts 'done.'
  end

  def obtain_url_of(file_name)
    service = connect_s3_service
    bucket = service.bucket(bucket_name)
    object = bucket.object(file_name)
    object.presigned_url(:get)
  end

  def download_to_temp_file(file_name)
    Dir.mktmpdir do |dir|
      @logger.print "Downloading file \"#{bucket_name}/#{file_name}\" to temp folder \"#{dir}\"..."
      temp_file = "#{dir}/#{Pathname(file_name).basename}"

      s3_client = connect_s3_client
      s3_client.get_object({ bucket: bucket_name, key: file_name }, target: temp_file)

      yield(temp_file)
    end
    logger.puts 'done.'
  rescue Aws::S3::Errors::NoSuchKey
    raise FileNotFoundError.new("#{bucket_name}/#{file_name}")
  end

  def list_files(prefix = '', file_extension = '*')
    # objects = []
    # last_key = nil
    # begin
    #   new_objects = AWS::S3::Bucket.objects(bucket_name, :marker => last_key)
    #   objects    += new_objects
    #   last_key    = objects.last.key
    # end while new_objects.size > 0
    #
    # bucket = s3_service.buckets[options[:bucket]]
    # bucket.each do |object|
    #    puts "#{object.key}\t#{object.about['content-length']}\t#{object.about['last-modified']}"
    # end

    s3_service = connect_s3_service
    bucket = s3_service.bucket(bucket_name)

    logger.print "Listing \"#{prefix}*.#{file_extension}\" from bucket \"#{bucket_name}\"..."

    files = []
    bucket.objects(prefix: prefix).each do |obj|
      if file_extension == '*' || obj.key.end_with?(".#{file_extension}")
        files << obj.key
      end
    end
    logger.puts 'done.'
    files
  end

  def delete_file file_name
    s3_service = connect_s3_service
    bucket = s3_service.bucket(bucket_name)
    logger.print "Deleting file \"#{file_name}\" from bucket \"#{bucket_name}\"..."
    bucket.object(file_name).delete
    logger.puts 'done.'
  end

  def rename_file original_file_name, target_file_name
    s3_service = connect_s3_service
    bucket = s3_service.bucket(bucket_name)
    logger.print "Renaming file \"#{original_file_name}\" \"#{target_file_name}\" from bucket \"#{bucket_name}\"..."
    bucket.object(original_file_name).move_to(bucket: bucket_name, key: target_file_name)
    logger.puts 'done.'
  rescue Aws::S3::Errors::NoSuchKey
    raise FileNotFoundError.new("#{bucket_name}/#{original_file_name}")
  end

  def copy_file source_file_name, target_file_name
    s3_service = connect_s3_service
    bucket = s3_service.bucket(bucket_name)
    logger.print "Copying file \"#{source_file_name}\" \"#{target_file_name}\" from bucket \"#{bucket_name}\"..."
    bucket.object(source_file_name).copy_to(bucket: bucket_name, key: target_file_name)
    logger.puts 'done.'
  rescue Aws::S3::Errors::NoSuchKey
    raise FileNotFoundError.new("#{bucket_name}/#{source_file_name}")
  end

  private

  def connect_s3_service
    logger.print "Accessing S3 service..."

    credentials = Aws::Credentials.new(options[:access_key_id], options[:secret_access_key])
    client      = Aws::S3::Client.new(region: options[:region], credentials: credentials)

    service = Aws::S3::Resource.new(client: client)
    logger.puts 'done.'
    service
  end

  def connect_s3_client
    credentials = Aws::Credentials.new(options[:access_key_id], options[:secret_access_key])
    Aws::S3::Client.new(region: options[:region], credentials: credentials)
  end

end
