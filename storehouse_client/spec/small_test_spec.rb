require 'spec_helper'
require 'storehouse_client'

describe 'Add one record' do

  it 'should add one record' do
    sc = StorehouseClient::API.new(url: 'http://localhost:3000', auth_token: 'z0000000000000000000')

    sc.start_run(1)

    hash = { value: 'two', type: 'test stuff', other_thing: 1}

    sc.add_record(1, hash)

    sc.finish_run
    sc.record_count.should eq(1)
  end

end