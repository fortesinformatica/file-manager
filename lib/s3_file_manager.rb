require 'file_manager'
require 'aws-sdk'

class S3FileManager < FileManager

  def read_file file_name
    s3_service = connect_s3_service
    bucket = s3_service.buckets[bucket_name]

    print "Reading file \"#{file_name}\" from bucket \"#{bucket_name}\"..."
    contents = bucket.objects[file_name].read.force_encoding('utf-8')
    puts 'done.'

    contents
  rescue AWS::S3::Errors::NoSuchKey
    raise FileNotFoundError.new("#{bucket_name}/#{file_name}")
  end

  def bucket_name
    options.fetch(:bucket)
  end

  def save_file(file_name, file_contents, write_options = {})
    print "Saving file \"#{file_name}\" to bucket \"#{bucket_name}\"..."
    s3_service = connect_s3_service
    bucket = s3_service.buckets[bucket_name]

    bucket.objects["#{file_name}"].write(file_contents.to_s, write_options)
    puts 'done.'
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
    bucket = s3_service.buckets[bucket_name]

    print "Listing \"#{prefix}*.#{file_extension}\" from bucket \"#{bucket_name}\"..."

    files = []
    bucket.objects.with_prefix(prefix).each(:limit => 1000) do |obj|
      if file_extension == '*' || obj.key.end_with?(".#{file_extension}")
        files << obj.key
      end
    end
    puts 'done.'
    files
  end

  def delete_file file_name
    s3_service = connect_s3_service
    bucket = s3_service.buckets[bucket_name]
    print "Deleting file \"#{file_name}\" from bucket \"#{bucket_name}\"..."
    bucket.objects[file_name].delete
    puts 'done.'
  end

  private

  def connect_s3_service
    print "Accessing S3 service..."

    AWS.config(
        :access_key_id => options[:access_key_id],
        :secret_access_key => options[:secret_access_key]
    )

    service = AWS::S3.new
    puts 'done.'
    service
  end

end
