# StorehouseClient

This the API client to the Storehouse application.

## Installation

Add this line to your application's Gemfile:

    gem 'storehouse_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install storehouse_client

## Usage

The storehouse_client is simple to use.  Here is a complete working example.  Assuming you have a one data source defined in the target Storehouse.

```ruby
#!/usr/bin/env ruby

require 'storehouse_client'

# Setup your data source in the web application, change this as required
data_source_id = 1

# Create a new client instance
sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

# Start the export run
sc.start_run(data_source_id)

# Iterate your data source, use a simple counter for the primary key
count = 0
File.open('/usr/share/dict/words').each do |line|

  count += 1

  sc.add_record(count, line)

  puts "Added #{line}"

end

sc.finish_run
```

See other examples in the 'examples' directory.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
