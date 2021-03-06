# File::Manager

[![Build Status](https://travis-ci.org/fortesinformatica/file-manager.svg?branch=master)](https://travis-ci.org/fortesinformatica/file-manager)
[![Code Climate](https://codeclimate.com/github/fortesinformatica/file-manager/badges/gpa.svg)](https://codeclimate.com/github/fortesinformatica/file-manager)

File manager local or S3

## Installation

Add this line to your application's Gemfile:

    gem 'file-manager'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install file-manager

## Usage

require 'file_manager_factory'

file_managers = {
            xml_data: {
                type: 'local',
                root_path:'/Users/franciscobarroso/reports/'
            },
            txt: {
                type: 'local',
                root_path:'/Users/franciscobarroso/reports/'
            }
        }

factory = FileManagerFactory.new(file_managers)

file_manager_txt = factory.create(:txt)

file_manager_txt.save_file('babau.txt', 'buuuu')

## Testing

```sh
export AWS_ACCESS_KEY_ID='' # with your keys
export AWS_SECRET_ACCESS_KEY=''
bundle exec rake
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
