redis-bloomfilter
=============
Requires the redis gem.

Adds Redis::Bloomfilter class which can be used as distributed bloom filter implementation on Redis.

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
---------------------------------------------
Benchmarking lua driver with 1000000 items
              user     system      total        real
insert:   38.620000  17.690000  56.310000 (160.377977)
include?: 43.420000  20.600000  64.020000 (175.055146)

---------------------------------------------
Benchmarking ruby driver with 1000000 items
              user     system      total        real
insert:  125.910000  20.250000 146.160000 (195.973994)
include?:121.230000  36.260000 157.490000 (231.360137)
```
The lua version is about ~3 times faster than the pure-Ruby version

Lua code is taken from https://github.com/ErikDubbelboer/redis-lua-scaling-bloom-filter

1.000.000 ~= 1.5Mb occupied on Redis

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
