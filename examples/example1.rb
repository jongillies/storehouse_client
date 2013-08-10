#!/usr/bin/env ruby

require 'storehouse_client'

# Setup your data source in the web application, change this as required
DATA_SOURCE_ID = 1

# Create a new client instance
sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

# Start the export run
sc.start_run(DATA_SOURCE_ID)

if sc.error?
  puts "We got an error! #{sc.error}"
  exit 1
end

# Iterate your data source, use a simple counter for the primary key
count = 0
File.open('/usr/share/dict/words').each do |line|

  count += 1
  sc.add_record(count, line)

  if sc.error?
    puts "We got an error! #{sc.error}"
    exit 1
  end

  puts "Added #{line}"

end

sc.finish_run

if sc.error?
  puts "We got an error! #{sc.error}"
  exit 1
end



