=begin

Some speed comparisions between standard Array and HArray.

=end

require 'trix/harray'
require 'benchmark'

$n = 50000

# standard array

def sarray_make
  $n.times do
    $sa = [1,'a',nil]
  end
end

def sarray_slice
  $n.times do
    $sa[1..2]
  end
end

# hash array

def harray_make
  $n.times do
    $ha = HArray.new_h({0=>1,1=>'a',2=>nil})
  end
end

def harray_slice
  $n.times do
    $ha[1..2]
  end
end


### --- bench ---

puts "\nCURRENT"
Benchmark.bm(15) do |b|
  b.report("HAarry#new:") { harray_make }
  b.report("HArray#slice:") { harray_slice }
  b.report("Array#new:") { sarray_make }
  b.report("Array#slice:") { sarray_slice }
end
