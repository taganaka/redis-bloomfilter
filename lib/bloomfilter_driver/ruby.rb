class Redis
  module BloomfilterDriver
    class Ruby
      attr_accessor :redis

      def initialize(options = {})
        @options = options
      end

      # Insert a new element
      def insert(data) 
        @redis.pipelined do
          indexes_for(data) { |i| @redis.setbit @options[:key_name], i, 1 }
        end
      end

      # It checks if a key is part of the set
      def include?(key)
        indexes = []
        indexes_for(key) { |idx| indexes << idx }

        return false if @redis.getbit(@options[:key_name], indexes.shift) == 0

        result = @redis.pipelined do
          indexes.each {|idx| @redis.getbit(@options[:key_name], idx)}
        end

        !result.include?(0)
      end

      # It deletes a bloomfilter
      def clear
        @redis.del @options[:key_name]
      end

      protected
        def indexes_for(key, engine = nil)
          engine ||= @options[:hash_engine]
          @options[:hashes].times do |i|
            yield self.send("engine_#{engine}", key.to_s, i)
          end
        end

        # A set of different hash functions
        def engine_crc32(data, i)
          Zlib.crc32("#{i}-#{data}").to_i(16) % @options[:bits]
        end

        def engine_md5(data, i)
          Digest::MD5.hexdigest("#{i}-#{data}").to_i(16) % @options[:bits]
        end

        def engine_sha1(data, i)
          Digest::SHA1.hexdigest("#{i}-#{data}").to_i(16) % @options[:bits]
        end
    end
  end
end