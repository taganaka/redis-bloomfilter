# frozen_string_literal: true

require 'redis-bloomfilter'

# It creates a Bloom Filter using the default ruby driver
# Number of elements expected : 10000
# Max error rate: 1%
# Key name on Redis: my-bloom-filter
# Redis: 127.0.0.1:6379 or an already existing connection
@bf = Redis::Bloomfilter.new(
  size: 10_000,
  error_rate: 0.01,
  key_name: 'my-bloom-filter'
)

# Insert an element
@bf.insert 'foo'
# Check if an element exists
puts @bf.include?('foo') # => true
puts @bf.include?('bar') # => false

# Empty the BF and delete the key stored on redis
@bf.clear

# Using Lua's driver: only available on Redis >= 2.6.0
# This driver should be prefered because is faster
@bf = Redis::Bloomfilter.new(
  size: 10_000,
  error_rate: 0.01,
  key_name: 'my-bloom-filter-lua',
  driver: 'lua'
)

# Specify a redis connection:
# @bf = Redis::Bloomfilter.new(
#   :size => 10_000,
#   :error_rate => 0.01,
#   :key_name   => 'my-bloom-filter-lua',
#   :driver     => 'lua',
#   :redis      => Redis.new(:host => "10.0.1.1", :port => 6380)
# )
