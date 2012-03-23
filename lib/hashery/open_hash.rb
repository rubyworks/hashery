# OpenHash is very similar to Ruby's own OpenStruct, but it offers some
# useful advantages in that it is a true Hash object.
#
# Because OpenHash is a subclass of Hash, it can do everything a Hash
# can *unless* a Hash method has been explicity exempted for use
# as an open read/writer via the #omit! method.

class OpenHash < Hash

  # New OpenHash.
  def initialize(data={})
    super()
    merge!(data)
  end

  #
  def <<(x)
    case x
    when Hash
      update(x)
    when Array
      x.each_slice(2) do |(k,v)|
        self[k] = v
      end
    end
  end

  #
  def respond_to?(name)
    key?(name.to_sym) || super(name)
  end

  #
  def to_h
    dup
  end

  #
  def to_hash
    dup
  end

  #
  def inspect
    super
  end

  # Omit specific Hash methods from slot protection.
  def omit!(*methods)
    methods.reject!{ |x| x.to_s =~ /^__/ }
    (class << self; self; end).class_eval{ private *methods }
  end

  # Route get and set calls.
  def method_missing(s,*a, &b)
    type = s.to_s[-1,1]
    name = s.to_s.sub(/[!?=]$/, '')
    key  = name.to_sym
    case type
    when '='
      self[key] = a[0]
    #when '!'
    #  self[s] = OpenHash.new
    when '?'
      key?(key)
    else
      if key?(key)
        self[key]
      else
        super(s,*a,&b)
      end
    end
  end

end
