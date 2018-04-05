# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'redis-bloomfilter'
require 'benchmark'
items = 100_000
error_rate = 0.01
%w[lua ruby].each do |driver|
  bf = Redis::Bloomfilter.new(
    {
      size: items,
      error_rate: error_rate,
      key_name: "bloom-filter-bench-flat-#{driver}",
      driver: driver
    }
  )
  bf.clear
  puts '---------------------------------------------'
  puts "Benchmarking #{driver} driver with #{items} items"
  Benchmark.bm(7) do |x|
    x.report('insert:  ') { items.times { |_i| bf.insert(rand(items)) } }
    x.report('include?:') { items.times { |_i| bf.include?(rand(items)) } }
  end
  puts
end
