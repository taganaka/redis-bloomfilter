$:.push File.expand_path("../lib", __FILE__)
require "redis-bloomfilter"
require "benchmark"
require "set"

def rand_word(length = 8)
  @charset ||= ('a'..'z').to_a
  @charset.shuffle.first(length).join
end

items = ARGV[0].to_i || 10_000
puts "#{items}"  
error_rate = 0.01
bf = Redis::Bloomfilter.new(
  {
    :size       => items, 
    :error_rate => error_rate, 
    :key_name   => "bloom-filter-bench"
  }
)
bf.clear
error = 0
first_error_at = 0
visited = Set.new

Benchmark.bm do |x| 
  x.report do
    items.times do |i|
      item = rand_word

      if bf.include?(item) != visited.include?(item)
        error += 1
        first_error_at = i if error == 1
      end
      visited << item
      bf.insert item
      print ".(#{"%.1f" % ((i.to_f/items.to_f) * 100)}%) " if i % 1000 == 0
    end
  end
end

puts "Bloomfilter no of Bits: #{bf.options[:bits]}"
puts "Bloomfilter no of hashes used: #{bf.options[:hashes]}"
puts "Items added: #{items}"
puts "First error found at: #{first_error_at}"
puts "Error found: #{error}"
puts "Error rate: #{(error.to_f / items)}"