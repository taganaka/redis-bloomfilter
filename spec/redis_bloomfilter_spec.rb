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

def factory options, driver
  options[:driver] = driver
  Redis::Bloomfilter.new options
end

describe Redis::Bloomfilter do

  it 'should return the right version' do
    Redis::Bloomfilter.version.should eq "redis-bloomfilter version #{Redis::Bloomfilter::VERSION}"
  end

  it 'should check for the initialize options' do
    expect { Redis::Bloomfilter.new }.to raise_error(ArgumentError)
    expect { Redis::Bloomfilter.new :size => 123 }.to raise_error(ArgumentError)
    expect { Redis::Bloomfilter.new :error_rate => 0.01 }.to raise_error(ArgumentError)
    expect { Redis::Bloomfilter.new :size => 123,:error_rate => 0.01, :driver => 'bibu' }.to raise_error(NameError)
  end

  it 'should create a Redis::Bloomfilter object' do
    bf = factory({:size => 1000, :error_rate => 0.01, :key_name => 'ossom'}, 'ruby')
    bf.should be
    bf.options[:size].should eq 1000
    bf.options[:bits].should eq 9585
    bf.options[:hashes].should eq 6
    bf.options[:key_name].should eq 'ossom'
    bf.clear
  end

  %w(ruby lua ruby-test).each do |driver|
    it 'should work' do
      bf = factory({:size => 1000, :error_rate => 0.01, :key_name => '__test_bf'},driver)
      bf.clear
      bf.include?("asdlol").should be false
      bf.insert "asdlol"
      bf.include?("asdlol").should be true
      bf.clear
      bf.include?("asdlol").should be false
    end

    it 'should honor the error rate' do
      bf = factory({:size => 100, :error_rate => 0.01, :key_name => '__test_bf'},driver)
      bf.clear
      e = test_error_rate bf, 180
      e.should be < bf.options[:error_rate]
      bf.clear
    end
  end

end