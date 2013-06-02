require "spec_helper"
require "set"


def test_error_rate(bf,elems)
  visited = Set.new
  error = 0
  elems.times do |i|
    a = rand(elems)
    error += 1 if bf.include?(a) != visited.include?(a)
    visited << a
    bf.insert a
  end
  error.to_f / elems
end

describe Redis::Bloomfilter do
  it 'should return the right version' do
    Redis::Bloomfilter.version.should eq "redis-bloomfilter version #{Redis::Bloomfilter::VERSION}"
  end

  it 'should check for the initialize options' do
    expect { Redis::Bloomfilter.new }.to raise_error(ArgumentError)
    expect { Redis::Bloomfilter.new :size => 123 }.to raise_error(ArgumentError)
    expect { Redis::Bloomfilter.new :error_rate => 0.01 }.to raise_error(ArgumentError)
  end

  it 'should create a Redis::Bloomfilter object' do
    bf = Redis::Bloomfilter.new :size => 1000, :error_rate => 0.01, :key_name => 'ossom'
    bf.should be
    bf.options[:size].should eq 1000
    bf.options[:bits].should eq 9585
    bf.options[:hashes].should eq 6
    bf.options[:key_name].should eq 'ossom'
  end

  it 'should work' do
    bf = Redis::Bloomfilter.new :size => 1000, :error_rate => 0.01, :key_name => '__test_bf'
    bf.clear
    bf.include?("asdlol").should be false
    bf.insert "asdlol"
    bf.include?("asdlol").should be true
    bf.clear
    bf.include?("asdlol").should be false
  end

  it 'should honor the eror rate' do
    bf = Redis::Bloomfilter.new :size => 100, :error_rate => 0.01, :key_name => '__test_bf'
    bf.clear
    e = test_error_rate bf, 180
    e.should be < bf.options[:error_rate]
    bf.clear
  end

end