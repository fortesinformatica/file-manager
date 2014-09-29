require 'aws-sdk'

class S3FileManager
  attr_accessor :options

  def initialize(options)
    @options = options
  end

  def read_file file_name
    s3_service = connect_s3_service
    bucket = s3_service.buckets[options[:bucket]]

    print "Reading file \"#{file_name}\" from bucket \"#{:bucket}\"..."
    contents = bucket.objects[file_name].read.force_encoding('utf-8')
    puts 'done.'

    contents
  end

  def save_file file_name, file_contents
    print "Saving file \"#{file_name}\" to bucket \"#{:bucket}\"..."
    s3_service = connect_s3_service
    bucket = s3_service.buckets[options[:bucket]]

    bucket.objects["#{file_name}"].write(file_contents.to_s)
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
