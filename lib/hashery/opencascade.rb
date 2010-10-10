require 'hashery/openhash'
#require 'facets/nullclass'

# = OpenCascade
#
# OpenCascade is subclass of OpenHash. It differs in a few
# significant ways.
#
# The main reason this class is labeled "cascade", every internal
# Hash is transformed into an OpenCascade dynamically upon access.
# This makes it easy to create "cascading" references.
#
#   h = { :x => { :y => { :z => 1 } } }
#   c = OpenCascade[h]
#   c.x.y.z  #=> 1
#
# As soon as you access a node it automatically becomes an OpenCascade.
#
#   c = OpenCascade.new   #=> #<OpenCascade:0x7fac3680ccf0 {}>
#   c.r                   #=> #<OpenCascade:0x7fac368084c0 {}>
#   c.a.b                 #=> #<OpenCascade:0x7fac3680a4f0 {}>
#
# But if you set a node, then that will be it's value.
#
#   c.a.b = 4             #=> 4
#
# To query a node without causing the auto-creation of an OpenCasade
# object, use the ?-mark.
#
#   c.a.z?                #=> nil
#
# OpenCascade also transforms Hashes within Arrays.
#
#  h = { :x=>[ {:a=>1}, {:a=>2} ], :y=>1 }
#  c = OpenCascade[h]
#  c.x.first.a.assert == 1
#  c.x.last.a.assert == 2
#
# Finally, you can set a node and get the reciever back using
# the !-mark.
#
#   c = OpenCascade.new   #=> #<OpenCascade:0x7fac3680ccf0 {}>
#   c.x!(4).y!(3)         #=> #<OpenCascade:0x7fac3680ccf0 {:x=>4, :y=>3}>
#
#--
# Last, when an entry is not found, 'null' is returned rather then 'nil'.
# This allows for run-on entries withuot error. Eg.
#
#   o = OpenCascade.new
#   o.a.b.c  #=> null
#
# Unfortuately this requires an explict test for null? in 'if' conditions.
#
#   if o.a.b.c.null?  # true if null
#   if o.a.b.c.nil?   # true if nil or null
#   if o.a.b.c.not?   # true if nil or null or false
#
# So be sure to take that into account.
#++

class OpenCascade < OpenHash

  #
  def method_missing(sym, *args, &blk)
    type = sym.to_s[-1,1]
    name = sym.to_s.gsub(/[=!?]$/, '').to_sym
    case type
    when '='
      self[name] = args.first
    when '!'
      #@hash.__send__(name, *args, &blk)
      __send__(name, *args, &blk)
    when '?'
      self[name]
    else
      if key?(name)
        self[name] = transform_entry(self[name])
      else
        self[name] = OpenCascade.new #self.class.new
      end
    end
  end

  private

    #
    def transform_entry(entry)
      case entry
      when Hash
        OpenCascade.new(entry) #self.class.new(val)
      when Array
        entry.map{ |e| transform_entry(e) }
      else
        entry
      end
    end

end

