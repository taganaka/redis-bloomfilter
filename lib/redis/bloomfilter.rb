require "digest/md5"
require "digest/sha1"
require "zlib"

class Redis
  class Bloomfilter

    VERSION = "0.0.1"

    def self.version
      "redis-bloomfilter version #{VERSION}"
    end

    attr_reader :options

    # Usage: Redis::Bloomfilter.new :size => 1000, :error_rate => 0.01
    # It creates a bloomfilter with a capacity of 1000 items and an error rate of 1%
    def initialize(options = {})
      @options = {
        :size         => 1000,
        :error_rate   => 0.01,
        :key_name     => 'redis-bloomfilter',
        :hash_engine  => 'md5',
        :redis        => Redis.current,
        :driver       => 'ruby'
      }.merge options

      raise ArgumentError, "options[:size] && options[:error_rate] cannot be nil" if options[:error_rate].nil? || options[:size].nil?

      #Size provided, compute hashes and bits

      @options[:size]       = options[:size]
      @options[:error_rate] = options[:error_rate] ? options[:error_rate] : @options[:error_rate]
      @options[:bits]       = Bloomfilter.optimal_m options[:size], @options[:error_rate]
      @options[:hashes]     = Bloomfilter.optimal_k options[:size], @options[:bits]

      @redis = @options[:redis] || Redis.current
      @options[:hash_engine] = options[:hash_engine] if options[:hash_engine]
      driver_class = Redis::BloomfilterDriver.const_get(@options[:driver].downcase.gsub(/(\w+)/){|s|s.capitalize})
      raise ArgumentError, "a driver with name #{@options[:driver]} is mot availabe" if driver_class.nil?
      @driver = driver_class.new @options
      @driver.redis = @redis 
    end

    # Methods used to calculate M and K
    # Taken from http://en.wikipedia.org/wiki/Bloom_filter#Probability_of_false_positives
    def self.optimal_m num_of_elements, false_positive_rate = 0.01
      (-1 * (num_of_elements) * Math.log(false_positive_rate) / (Math.log(2) ** 2)).round
    end

    def self.optimal_k num_of_elements, bf_size
      h = (Math.log(2) * (bf_size / num_of_elements)).round
      h+=1 if h == 0
      h
    end

    # Insert a new element
    def insert(data)
      @driver.insert data
    end

    # It checks if a key is part of the set
    def include?(key)
      @driver.include?(key)
    end

    # It deletes a bloomfilter
    def clear
      @driver.clear
    end

  end
end