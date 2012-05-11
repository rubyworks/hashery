require 'benchmark'

class ProcVsCall

  def initialize(&proc)
    @the_proc = proc
  end

  def the_proc
    @the_proc ||= Proc.new{ |*x| x }
  end

  def call(*x)
    @the_proc ? @the_proc.call(*x) : x
  end

end

c = ProcVsCall.new

n = 50000

Benchmark.bmbm do |x|
  x.report('proc') { n.times { c.the_proc[:foo] } }
  x.report('call') { n.times { c.call(:foo) } }
end

c = ProcVsCall.new{ |x| x.class }

Benchmark.bmbm do |x|
  x.report('proc') { n.times{ c.the_proc[:foo] } }
  x.report('call') { n.times{ c.call(:foo) } }
end

# The results would indicate that it is better to define a default proc rather then
# using a call to check if it exists.

