require 'spec_helper'
require 'storehouse_client'

describe 'Initializing the class' do

  it 'should fail with no options' do
    expect { StorehouseClient::API.new({}) }.to raise_error
  end

  it 'should fail without the :url option' do
    expect { StorehouseClient::API.new(auth_token: 'z0000000000000000000') }.to raise_error
  end

  it 'should fail without the :auth_token option' do
    expect { StorehouseClient::API.new(url: 'http://localhost:3000') }.to raise_error
  end

  it 'should succeed with the proper options' do
    expect { StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000') }.not_to raise_error
  end

end

describe 'Fail me' do

  it 'should fail with an invalid auth_token' do
    sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z00000000000000000xxxx')

    sc.start_run(1)

    sc.error.http_code.should eq(401)

  end

  it 'should fail with an invalid data_source_id' do
    sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

    sc.start_run(100)

    sc.error.http_code.should eq(422)

  end

  it 'should fail with a duplicate record' do
    sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

    sc.start_run(1)

    text = RandomText.new.output(10).capitalize + '.'

    sc.add_record(1, text)
    sc.add_record(1, text)

    sc.error.http_code.should eq(422)

  end

end

describe 'Loading data_sources' do

  it 'should load the data sources' do
    sc = StorehouseClient::API.new(url: 'http://localhost:3000/api/1', auth_token: 'z0000000000000000000')
    sc.data_sources['count'].should eq(4)
  end

end

describe 'Starting and Stopping Runs' do

  it 'should start a run' do
    sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

    sc.start_run(1)

    sc.data_source_id.should eq(1)
  end

  it 'should start and end a run' do
    sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')
    sc.start_run(1)

    sc.finish_run

    sc.record_count.should eq(0)
  end

end

describe 'Add records and ensure types are converted properly' do

  it 'should ensure the primary key is a string' do
    sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

    sc.start_run(1)

    text = RandomText.new.output(10).capitalize + '.'

    sc.add_record(1, text)

    sc.finish_run
    sc.record_count.should eq(1)

  end

  it 'should convert the "data" to JSON if it is not a string' do
    sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

    sc.start_run(1)

    hash = { value: 'two', type: 'test stuff', other_thing: 1}

    sc.add_record(1, hash)

    sc.finish_run
    sc.record_count.should eq(1)
  end

end

describe 'Adding Export Records' do

  it 'should add unique export records' do

    record_count = 10
    data_source_id = 1

    sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

    sc.start_run(data_source_id)

    record_count.times do |i|

      text = RandomText.new.output(10).capitalize + '.'

      sc.add_record(i, text)

    end

    sc.finish_run
    sc.record_count.should eq(record_count)

  end

  it 'should start and end a run' do
    sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')
    sc.start_run(1)

    sc.finish_run

    sc.record_count.should eq(0)
  end

end