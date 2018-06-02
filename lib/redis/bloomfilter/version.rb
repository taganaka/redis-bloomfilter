# frozen_string_literal: true

class Redis
  class Bloomfilter
    VERSION = '1.0.1'
    def self.version
      "redis-bloomfilter version #{VERSION}"
    end
  end
end
