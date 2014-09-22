require 'spec_helper'

describe SpikePay do
  before :each do
    @spike = SpikePay.new('sk_test_key')
  end

  it 'has a version number' do
    expect(SpikePay::VERSION).not_to be nil
  end

  it 'should initalize correctly' do
    expect(@spike.conn.host).to eq "api.spike.cc"
    expect(@spike.charge).not_to be nil
  end

end
