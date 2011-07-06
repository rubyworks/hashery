require 'hashery/basicobject'

#require 'facets/hash/to_h'
#require 'facets/kernel/object_class'
#require 'facets/kernel/object_hexid'

# = BasicStruct
#
# BasicObject is very similar to Ruby's own OpenStruct, but it offers some
# advantages. With OpenStruct, slots with the same name as predefined
# Object methods cannot be used. With BasicObject, almost any slot can be
# defined. BasicObject is a subclass of BasicObject to ensure all method
# slots, except those that are absolutely essential, are open for use.
#
#--
# If you wish to pass an BasicObject to a routine that normal takes a Hash,
# but are uncertain it can handle the distictions properly you can convert
# easily to a Hash using #as_hash! and the result will automatically be
# converted back to an BasicObject on return.
#
#   o = BasicObject.new(:a=>1,:b=>2)
#   o.as_hash!{ |h| h.update(:a=>6) }
#   o #=> #<BasicObject {:a=>6,:b=>2}>
#++
#
# Unlike a Hash, all BasicObject's keys are symbols and all keys are converted
# to such using #to_sym on the fly.

class BasicStruct < BasicObject

  #PUBLIC_METHODS = /(^__|^instance_|^object_|^\W|^as$|^send$|^class$|\?$)/
  #protected(*public_instance_methods.select{ |m| m !~ PUBLIC_METHODS })

  def self.[](hash=nil)
    new(hash)
  end

  # Inititalizer for BasicObject is slightly different than that of Hash.
  # It does not take a default parameter, but an initial priming Hash,
  # like OpenStruct. The initializer can still take a default block
  # however. To set the default value use <code>#default!(value)</code>.
  #
  #   BasicObject.new(:a=>1).default!(0)
  #
  def initialize(hash=nil, &yld)
    @table = ::Hash.new(&yld)
    if hash
      hash.each{ |k,v| store(k,v) }
    end
  end

  #
  def initialize_copy(orig)
    orig.each{ |k,v| store(k,v) }
  end

  # Object inspection.
  # TODO: Need to get __class__ and __id__ in hex form.
  def inspect
    #@table.inspect
    hexid = __id__
    klass = "BasicObject" # __class__
    "#<#{klass}:#{hexid} #{@table.inspect}>"
  end

  # Convert to an associative array.
  def to_a
    @table.to_a
  end

  #
  def to_h
    @table.dup
  end

  #
  def to_hash
    @table.dup
  end

  #
  def to_basicstruct
    self
  end

  # Convert to an assignment procedure.
  def to_proc(response=false)
    hash = @table
    if response
      lambda do |o|
        hash.each do |k,v|
          o.__send__("#{k}=", v) rescue nil
        end
      end
    else
      lambda do |o|
        hash.each{ |k,v| o.__send__("#{k}=", v) }
      end
    end
  end

  # NOT SURE ABOUT THIS
  def as_hash
    @table
  end

  # Is a given +key+ defined?
  def key?(key)
    @table.key?(key.to_sym)
  end

  #
  def is_a?(klass)
    return true if klass == ::Hash  # TODO: Is this wise? How to fake a subclass?
    return true if klass == ::BasicObject
    false
  end

  # Iterate over each key-value pair.
  def each(&yld)
    @table.each(&yld)
  end

  # Set the default value.
  def default!(default)
    @table.default = default
  end

  # Check equality.
  def ==( other )
    case other
    when BasicObject
      @table == other.as_hash
    when Hash
      @table == other
    else
      if other.respond_to?(:to_hash)
        @table == other.to_hash
      else
        false
      end
    end
  end

  #
  def eql?( other )
    case other
    when BasicObject
      @table.eql?(other.as_hash)
    else
      false
    end
  end

  #
  def <<(x)
    case x
    when ::Hash
      @table.update(x)
    when ::Array
      x.each_slice(2) do |(k,v)|
        @table[k] = v
      end
    end
  end

  #
  def []=(key, value)
    @table[key.to_sym] = value
  end

  #
  def [](key)
    @table[key.to_sym]
  end

  #
  def merge!(other)
    BasicObject.new(@table.merge!(other))
  end

  #
  def update!(other)
    @table.update(other)
    self
  end

  protected

    def store(k, v)
      @table.store(k.to_sym, v)
    end

    def fetch(k, *d, &b)
      @table.fetch(k.to_sym, *d, &b)
    end

    #def as_hash!
    #  Functor.new do |op,*a,&b|
    #    result = @table.__send__(op,*a,&b)
    #    case result
    #    when Hash
    #      BasicObject.new(result)
    #    else
    #      result
    #    end
    #  end
    #end

    #def define_slot(key, value=nil)
    #  @table[key.to_sym] = value
    #end

    #def protect_slot( key )
    #  (class << self; self; end).class_eval {
    #    protected key rescue nil
    # }
    #end

    def method_missing(sym, *args, &blk)
      type = sym.to_s[-1,1]
      key  = sym.to_s.sub(/[=?!]$/,'').to_sym
      case type
      when '='
        store(key, args[0])
      when '!'
        @table.__send__(key, *args, &blk)
      #  if key?(key)
      #    fetch(key)
      #  else
      #    store(key, BasicObject.new)
      #  end
      when '?'
        fetch(key)
      else
        fetch(key)
      end
    end

end

# Core Extensions

class Hash
  # Convert a Hash into a BasicStruct.
  def to_basicstruct
    BasicStruct[self]
  end
end

=begin
class NilClass
  # Nil converts to an empty BasicObject.
  def to_basicstruct
    BasicObject.new
  end
end

class Proc
  # Translates a Proc into an BasicObject. By droping an BasicObject into
  # the Proc, the resulting assignments incured as the procedure is
  # evaluated produce the BasicObject. This technique is simlar to that
  # of MethodProbe.
  #
  #   p = lambda { |x|
  #     x.word = "Hello"
  #   }
  #   o = p.to_basicstruct
  #   o.word #=> "Hello"
  #
  # NOTE The Proc must have an arity of one --no more and no less.
  def to_basicstruct
    raise ArgumentError, 'bad arity for converting Proc to basicstruct' if arity != 1
    o = BasicObject.new
    self.call( o )
    o
  end
end
=end

