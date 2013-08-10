#!/usr/bin/env ruby

require 'storehouse_client'
require 'yaml'
require 'fog'
require 'logger'

logger         = Logger.new

# Setup your data source in the web application, change this as required
DATA_SOURCE_ID = 1

# Create a new client instance
sc             = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

# Start the export run
sc.start_run(DATA_SOURCE_ID)

if sc.error?
  puts "We got an error! #{sc.error}"
  exit 1
end

connection = Fog::Compute.new(:provider              => 'AWS',
                              :aws_access_key_id     => ENV['access_key_id'],
                              :aws_secret_access_key => ENV['secret_access_key'])

regions = []
connection.describe_regions.body['regionInfo'].each do |region|
  regions << region['regionName'] if region['regionName'] =~ /^us-/
end

regions.each do |region|
  connection = Fog::Compute.new(:provider              => 'AWS',
                                :aws_access_key_id     => ENV['access_key_id'],
                                :aws_secret_access_key => ENV['secret_access_key'],
                                :region                => region)

  servers = connection.servers

  begin
    servers.each do |server|
      sc.add_record(server.id, server)
      if sc.error?
        logger.log 'fatal', "#{server.id} sc.error.message", sc.error
      end
    end
  end

end

sc.finish_run
if sc.error?
  logger.log 'fatal', sc.error.message, sc.error
  exit 1
end


