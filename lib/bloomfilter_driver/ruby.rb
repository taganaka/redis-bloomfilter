# frozen_string_literal: true

require 'digest/sha1'
class Redis
  module BloomfilterDriver
    class Ruby
      # Faster Ruby version.
      # This driver should be used if Redis version < 2.6
      attr_accessor :redis
      def initialize(options = {})
        @options = options
      end

      # Insert a new element
      def insert(data)
        set data
      end

      # It checks if a key is part of the set
      def include?(key)
        indexes = []
        indexes_for(key).each { |idx| indexes << idx }
        return false if @redis.getbit(@options[:key_name], indexes.shift).zero?

        result = @redis.pipelined do
          indexes.each { |idx| @redis.getbit(@options[:key_name], idx) }
        end

        !result.include?(0)
      end

      # It deletes a bloomfilter
      def clear
        @redis.del @options[:key_name]
      end

      protected

      # Hashing strategy:
      # https://www.eecs.harvard.edu/~michaelm/postscripts/tr-02-05.pdf
      def indexes_for(data)
        sha = Digest::SHA1.hexdigest(data.to_s)
        h = []
        h[0] = sha[0...8].to_i(16)
        h[1] = sha[8...16].to_i(16)
        h[2] = sha[16...24].to_i(16)
        h[3] = sha[24...32].to_i(16)
        idxs = []

        (@options[:hashes]).times do |i|
          v = (h[i % 2] + i * h[2 + (((i + (i % 2)) % 4) / 2)]) % @options[:bits]
          idxs << v
        end
        idxs
      end

      def set(key)
        @redis.pipelined do
          indexes_for(key).each { |i| @redis.setbit @options[:key_name], i, 1 }
        end
      end
    end
  end
end
