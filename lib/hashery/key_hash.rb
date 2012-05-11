require 'hashery/crud_hash'

module Hashery

  # The KeyHash class is a Hash compatible class which converts
  # all keys to strings. This has two advantages. First it
  # means hash entries have indifferent access. <tt>1</tt>,
  # <tt>"1"</tt> and <tt>:1</tt> are all equivalent. Any object
  # that defines <tt>#to_s</tt> can be used as a key. Secondly,
  # since strings are garbage collected so are KeyHash objects. 
  # 
  # The KeyHash class works like a normal Hash. But notice the
  # significant distinction of indifferent key access.
  # 
  #   s = KeyHash.new
  #   s[:x] = 1
  #   s[:x]       #=> 1
  #   s['x']      #=> 1
  # 
  # We can see that internally the key has indeed been converted
  # to a String.
  # 
  #   s.to_h      #=> {'x'=>1 }
  # 
  # Becuase of the way in which KeyHash is designed, it has a nice
  # secondary usage. KeyHash defines a private method called
  # #convert_key. This method handles the conversion of the key
  # whenever the underlying hash is altered. If you have need
  # for a different kind of Hash, one the has a special restraint
  # on the key, it is easy enough to subclass KeyHash and override
  # the is method. Eg.
  # 
  #   class Upash < KeyHash
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
  # NOTE: KeyHash does not yet handle default_proc.

  class KeyHash < CRUDHash

    #
    def self.[](*hash)
      s = new
      super(*hash).each{ |k,v| s[k] = v }
      s
    end

    #
    def initialize(*args, &block)
      #@key_proc = Proc.new{ |k| k.to_s }
      new(*args, &block)
    end

    #
    def to_hash
      h = {}; each{ |k,v| h[k] = v }; h
    end

    alias_method :to_h, :to_hash

  private

    def convert_key(key)
      @key_proc ? super(key) : key.to_s
    end

  end

end

class Hash
  # Convert a Hash to a KeyHash object.
  def to_keyhash
    Hashery::KeyHash[self]
  end
end

