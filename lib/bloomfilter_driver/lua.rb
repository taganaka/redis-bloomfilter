# frozen_string_literal: true

require 'digest/sha1'
class Redis
  module BloomfilterDriver
    # It loads lua script into redis.
    # BF implementation is done by lua scripting
    # The alghoritm is executed directly on redis
    # Credits for lua code goes to Erik Dubbelboer
    # https://github.com/ErikDubbelboer/redis-lua-scaling-bloom-filter
    class Lua
      attr_accessor :redis

      def initialize(options = {})
        @options = options
        @redis = @options[:redis]
        lua_load
      end

      def insert(data)
        set data
      end

      def include?(key)
        r = @redis.evalsha(@check_fnc_sha, keys: [@options[:key_name]], argv: [@options[:size], @options[:error_rate], key])
        r == 1
      end

      def clear
        @redis.keys("#{@options[:key_name]}:*").each { |k| @redis.del k }
      end

      protected

      # It loads the script inside Redis
      # Taken from https://github.com/ErikDubbelboer/redis-lua-scaling-bloom-filter
      # This is a scalable implementation of BF. It means the initial size can vary
      def lua_load
        add_fnc = File.read File.expand_path("../../vendor/assets/lua/add.lua", __dir__)
        check_fnc = File.read File.expand_path("../../vendor/assets/lua/check.lua", __dir__)

        @add_fnc_sha   = Digest::SHA1.hexdigest(add_fnc)
        @check_fnc_sha = Digest::SHA1.hexdigest(check_fnc)

        loaded = @redis.script(:exists, [@add_fnc_sha, @check_fnc_sha]).uniq
        return unless loaded.count != 1 || loaded.first != true
        @add_fnc_sha   = @redis.script(:load, add_fnc)
        @check_fnc_sha = @redis.script(:load, check_fnc)
      end

      def set(data)
        @redis.evalsha(@add_fnc_sha, keys: [@options[:key_name]], argv: [@options[:size], @options[:error_rate], data])
      end
    end
  end
end
