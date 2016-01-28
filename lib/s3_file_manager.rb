require 'file_manager'
require 'aws-sdk'

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

  private

  def connect_s3_service
    logger.print "Accessing S3 service..."

    credentials = Aws::Credentials.new(options[:access_key_id], options[:secret_access_key])

    client = Aws::S3::Client.new(region:'us-west-2', credentials: credentials)

    service = Aws::S3::Resource.new(client: client)
    logger.puts 'done.'
    service
  end

end
