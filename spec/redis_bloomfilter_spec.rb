require "spec_helper"

describe Redis::Bloomfilter do
  it 'should return the right version' do
    Redis::Bloomfilter.version.should eq "redis-bloomfilter version #{Redis::Bloomfilter::VERSION}"
  end
end