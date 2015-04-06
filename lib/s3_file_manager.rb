require 'aws-sdk'

class S3FileManager
  attr_accessor :options

  def initialize(options)
    @options = options
  end

  def read_file file_name
    s3_service = connect_s3_service
    bucket = s3_service.buckets[options[:bucket]]

    print "Reading file \"#{file_name}\" from bucket \"#{options[:bucket]}\"..."
    contents = bucket.objects[file_name].read.force_encoding('utf-8')
    puts 'done.'

    contents
  end

  def save_file(file_name, file_contents, write_options = {})
    print "Saving file \"#{file_name}\" to bucket \"#{options[:bucket]}\"..."
    s3_service = connect_s3_service
    bucket = s3_service.buckets[options[:bucket]]

    bucket.objects["#{file_name}"].write(file_contents.to_s, write_options)
    puts 'done.'
  end

  def list_files
#    objects = []
#    last_key = nil
#    begin
#      new_objects = AWS::S3::Bucket.objects(bucket_name, :marker => last_key)
#      objects    += new_objects
#      last_key    = objects.last.key
#    end while new_objects.size > 0
     #TODO
     bucket = s3_service.buckets[options[:bucket]]
     bucket.each do |object|
        puts "#{object.key}\t#{object.about['content-length']}\t#{object.about['last-modified']}"
     end
  end

  def delete_file file_name
    #TODO
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
