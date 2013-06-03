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
  * A server-side version based on lua available for Redis v > 2.6


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
