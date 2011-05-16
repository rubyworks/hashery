# The Stash class is a Hash compatible class which converts
# all keys to strings. This has two advantages. First it
# means hash entries have indifferent access. <tt>1</tt>,
# <tt>"1"</tt> and <tt>:1</tt> are all equivalent. Any object
# that defines <tt>#to_s</tt> can be used as a key. Secondly,
# since strings are garbage collected so are Stash objects. 
# 
# The Stash class works like a normal Hash. But notice the
# significant distinction of indifferent key access.
# 
#   s = Stash.new
#   s[:x] = 1
#   s[:x]       #=> 1
#   s['x']      #=> 1
# 
# We can see that internally the key has indeed been converted
# to a String.
# 
#   s.to_h      #=> {'x'=>1 }
# 
# Becuase of the way in which Stash is designed, it has a nice
# secondary usage. Stash defines a private method called
# #convert_key. This method handles the conversion of the key
# whenever the underlying hash is altered. If you have need
# for a different kind of Hash, one the has a special restraint
# on the key, it is easy enough to subclass Stash and override
# the is method. Eg.
# 
#   class Upash < Stash
#     def convert_key(key)
#       key.to_s.upcase
#     end
#   end
# 
#   u = Upash.new
#   u.replace(:a=>1, :b=>2)
#   u.to_h  #=> { 'A'=>1, 'B'=>2 }
#
#
# NOTE: Stash does not yet handle default_proc.

class Stash < Hash

  #
  def self.[](*hash)
    s = new
    super(*hash).each{ |k,v| s[k] = v }
    s
  end

  #
  def [](key)
    super(convert_key(key))
  end

  #
  def []=(key,value)
    super(convert_key(key), value)
  end

  #
  def <<(other)
    case other
    when Hash
      super(other.rekey{ |key| convert_key(key) })
    when Array
      self[other[0]] = other[1]
    else
      raise ArgumentError
    end
  end

  #
  def fetch(key)
    super(convert_key(key))
  end

  #
  def store(key, value)
    super(convert_key(key), value)
  end

  #
  def key?(key)
    super(convert_key(key))
  end

  #
  def has_key?(key)
    super(convert_key(key))
  end

  #
  def include?(key)
    super(convert_key(key))
  end

  #
  def member?(key)
    super(convert_key(key))
  end


  # Synonym for Hash#rekey, but modifies the receiver in place (and returns it).
  #
  #   foo = { :name=>'Gavin', :wife=>:Lisa }.to_stash
  #   foo.rekey!{ |k| k.upcase }  #=>  { "NAME"=>"Gavin", "WIFE"=>:Lisa }
  #   foo.inspect                 #=>  { "NAME"=>"Gavin", "WIFE"=>:Lisa }
  #
  def rekey!(*args, &block)
    # for backward comptability (TODO: DEPRECATE?).
    block = args.pop.to_sym.to_proc if args.size == 1
    if args.empty?
      block = lambda{|k| k} unless block
      keys.each do |k|
        nk = block[k]
        self[nk.to_s]=delete(k) #if nk
      end
    else
      raise ArgumentError, "3 for 2" if block
      to, from = *args
      self[to] = delete(from) if has_key?(from)
    end
    self
  end

  #
  def rekey(*args, &block)
    dup.rekey!(*args, &block)
  end

  #
  def delete(key)
    super(convert_key(key))
  end

  #
  def update(other)
    super(other.rekey{ |key| convert_key(key) })
  end

  # Same as #update.
  def merge!(other)
    super(other.rekey{ |key| convert_key(key) })
  end

  #
  def merge(other)
    super(other.rekey{ |key| convert_key(key) })
  end

  #
  def replace(other)
    super(other.rekey{ |key| convert_key(key) })
  end

  #
  def values_at(*keys)
    super(*keys.map{ |key| convert_key(key) })
  end

  #
  def to_hash
    h = {}
    each{ |k,v| h[k] = v }
    h
  end

  alias_method :to_h, :to_hash

  private

    def convert_key(key)
      key.to_s
    end

end

class Hash

  # Convert a Hash to a Stash object.
  def to_stash
    Stash[self]
  end

  # Synonym for Hash#rekey, but modifies the receiver in place (and returns it).
  #
  #   foo = { :name=>'Gavin', :wife=>:Lisa }
  #   foo.rekey!{ |k| k.to_s }  #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #   foo.inspect               #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #
  # This method comes from Ruby Facets.

  def rekey!(*args, &block)
    # for backward comptability (TODO: DEPRECATE).
    block = args.pop.to_sym.to_proc if args.size == 1
    if args.empty?
      block = lambda{|k| k.to_sym} unless block
      keys.each do |k|
        nk = block[k]
        self[nk]=delete(k) if nk
      end
    else
      raise ArgumentError, "3 for 2" if block
      to, from = *args
      self[to] = self.delete(from) if self.has_key?(from)
    end
    self
  end

  # Non-inplace #rekey! method.
  def rekey(*args, &block)
    dup.rekey!(*args, &block)
  end

end

