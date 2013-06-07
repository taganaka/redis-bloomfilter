redis-bloomfilter
=============
Requires the redis gem.

Adds Redis::Bloomfilter class which can be used as ditributed bloom filter implementation on Redis.

A Bloom filter is a space-efficient probabilistic data structure that is used to test whether an element is a member of a set.


Installation
----------------
    $ gem install redis-bloomfilter

Testing
----------------
    $ bundle install
    $ rake

Drivers
-----------------
The library contains a set of different drivers.
  * A pure Ruby implementation
  * A server-side version based on lua available for Redis v. >= 2.6

How to use
-----------------
```ruby
require "redis-bloomfilter"

# It creates a Bloom Filter using the default ruby driver
# Number of elements expected : 10000
# Max error rate: 1%
# Key name on Redis: my-bloom-filter
# Redis: 127.0.0.1:6379 or an already existing connection
@bf = Redis::Bloomfilter.new(
  :size => 10_000, 
  :error_rate => 0.01, 
  :key_name => 'my-bloom-filter'
)

# Insert an element
@bf.insert "foo"
# Check if an element exists
puts @bf.include?("foo") # => true
puts @bf.include?("bar") # => false

# Empty the BF and delete the key stored on redis
@bf.clear

# Using Lua's driver: only available on Redis >= 2.6.0
# This driver should be prefered because is faster
@bf = Redis::Bloomfilter.new(
  :size => 10_000, 
  :error_rate => 0.01, 
  :key_name   => 'my-bloom-filter-lua',
  :driver     => 'lua'
)

# Specify a redis connection:
# @bf = Redis::Bloomfilter.new(
#   :size => 10_000, 
#   :error_rate => 0.01, 
#   :key_name   => 'my-bloom-filter-lua',
#   :driver     => 'lua',
#   :redis      => Redis.new(:host => "10.0.1.1", :port => 6380)
# )
```

Performance & Memory Usage
-----------------
```
Benchmarking lua driver with 1000000 items
              user     system      total        real
insert:   36.590000  17.510000  54.100000 (191.411008)
include?: 34.850000  16.520000  51.370000 (142.801983)

---------------------------------------------
Benchmarking ruby driver with 1000000 items
              user     system      total        real
insert:  101.630000  16.610000 118.240000 (164.792045)
include?: 96.440000  28.710000 125.150000 (191.021710)
```
The lua version is about ~3 times faster than the pure-Ruby version

Lua code is taken from https://github.com/ErikDubbelboer/redis-lua-scaling-bloom-filter

1.000.000 ~= 1.5Mb occuped on Redis

Contributing to redis-bloomfilter
----------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
----------------

Copyright (c) 2013 Francesco Laurita. See LICENSE.txt for
further details.
