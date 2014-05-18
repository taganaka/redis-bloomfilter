# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redis/bloomfilter/version"

Gem::Specification.new do |s|
  s.name        = "redis-bloomfilter"
  s.version     = Redis::Bloomfilter::VERSION
  s.authors     = ["Francesco Laurita"]
  s.email       = ["francesco.laurita@gmail.com"]
  s.homepage    = "https://github.com/taganaka/redis-bloomfilter"
  s.summary     = %q{Distributed Bloom Filter implementation on Redis}
  s.description = %q{
    Adds Redis::Bloomfilter class which can be used as ditributed bloom filter implementation on Redis.
    A Bloom filter is a space-efficient probabilistic data structure that is used to test whether an element is a member of a set.
  }
  s.licenses = ['MIT']
  s.rubyforge_project = "redis-bloomfilter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'hiredis', '~> 0.4', '>= 0.4.5'
  s.add_runtime_dependency 'redis', '~> 3.0', '>= 3.0.4'

  s.add_development_dependency "rspec"
  s.add_development_dependency "flexmock"
  s.add_development_dependency "rake"

end
