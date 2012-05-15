require 'hashery/crud_hash'

module Hashery

  # CastingHash is just like CRUDHash, except that both keys and values
  # can be passed through casting procedures.
  #
  class CastingHash < CRUDHash

    #
    def self.[](hash)
      s = new
      hash.each{ |k,v| s[k] = v }
      s
    end

    #
    # Unlike traditional Hash a CastingHash's block argument
    # coerces key/value pairs when #store is called.
    #
    def initialize(default=nil, &cast_proc)
      @cast_proc = cast_proc
      super(default, &nil)
    end

    #
    # The cast procedure.
    #
    def cast_proc(&block)
      @cast_proc = block if block
      @cast_proc
    end

    #
    def cast_proc=(proc)
      raise ArgumentError unless Proc === proc or NilClass === proc
      @cast_proc = proc
    end

    # CRUD method for create and update.
    def store(key, value)
      super(*cast_pair(key, value))
    end

    #
    def replace(other)
      super cast(other)
    end

    #
    def to_hash
      h = {}; each{ |k,v| h[k] = v }; h
    end

    #
    alias_method :to_h, :to_hash

    #
    def recast!
      replace self
    end

  private

    def cast_pair(key, value)
      if cast_proc
        return cast_proc.call(key, value)
      else
        return key, value
      end
    end

    #
    # Cast a given +hash+ according to the `#key_proc` and `#value_proc`.
    #
    # @param [#each] hash
    #
    def cast(hash)
      h = {}
      hash.each do |k,v|
        k, v = cast_pair(k, v)
        h[k] = v
      end
      h
    end

  end

end

#class Hash
#
#  # Convert a Hash to a CastingHash.
#  def to_casting_hash(value_cast=nil, &key_cast)
#    CastingHash.new(self, value_cast, &key_cast)
#  end
#
#end
