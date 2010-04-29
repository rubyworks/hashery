# Some speed comparisions between standard Array
# and SparseArray.

require 'hashery/sparsearray'
require 'benchmark'

$n = 10000
$a = [1,'a',nil,nil,nil,2,'b'] * 20
$s = SparseArray[*$a]

def bench_array_new
  $n.times do
    [1,'a',nil]
  end
end

def bench_sparse_array_new
  $n.times do
    SparseArray[*$a]
  end
end

def bench_slice(array)
  $n.times{ array[1] }
  $n.times{ array[1..2] }
end

def bench_set(array)
  $n.times{ |i| array[i] = i }
end

def bench_each(array)
  $n.times{ array.each{ |v| v } }
end

def bench_sparse(klass)
  #
  a = klass.new
  $n.times{ a[1000] = :x }
  #
  a = klass.new
  a[1000] = :x
  a.each{ |e| e }
end

Benchmark.bmbm(20) do |b|
  b.report("Array") { bench_sparse(Array) }
  b.report("Array.new") { bench_array_new }
  b.report("Array#each") { bench_each($a) }
  b.report("Array#[]") { bench_slice($a) }
  b.report("Array#[]=") { bench_set([]) }

  b.report("SparseArray") { bench_sparse(SparseArray) }
  b.report("SparseArray.new") { bench_sparse_array_new }
  b.report("SparseArray#each") { bench_each($s) }
  b.report("SparseArray#[]") { bench_slice($s) }
  b.report("SparseArray#[]=") { bench_set(SparseArray.new) }
end

