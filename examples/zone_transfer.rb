#!/usr/bin/env ruby

require 'storehouse_client'
require 'yaml'
require 'dnsruby'
require 'logger'

logger = Logger.new

# Setup your data source in the web application, change this as required
DATA_SOURCE_ID = 1
DOMAIN = 'example.com'

# Create a new client instance
sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

# Start the export run
sc.start_run(DATA_SOURCE_ID)

if sc.error?
  puts "We got an error! #{sc.error}"
  exit 1
end

begin
  zt               = Dnsruby::ZoneTransfer.new
  zt.transfer_type = Dnsruby::Types.AXFR
  zone             = zt.transfer(DOMAIN)
rescue Exception => e
  logger.log 'fatal', e.message, e
  exit 1
end

zone.each do |rec|

  # Create an artificial primary key based on the MD5 of the string
  sc.add_record(Digest::MD5.hexdigest(rec.to_s), rec)
  if sc.error?
    logger.log 'fatal', "#{Digest::MD5.hexdigest(rec.to_s)} sc.error.message", sc.error
  end

end

sc.finish_run
if sc.error?
  logger.log 'fatal', sc.error.message, sc.error
  exit 1
end


