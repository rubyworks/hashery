require 'hashery/crud_hash'

module Hashery

  # CastingHash is just like CRUDHash, except that both keys and values
  # can be passed through casting procedures.
  #
  # The `#value_proc` only effects storing. Perhaps a cast procedure for
  # read value might be a useful feature, but is currently not supported.
  #
  class CastingHash < CRUDHash

    #
    def self.[](hash)
      s = new
      hash.each{ |k,v| s[k] = v }
      s
    end

    #
    def value_proc(&block)
      @value_proc = block if block
      @value_proc
    end

    #
    def value_proc=(proc)
      raise ArgumentError unless Proc === proc or NilClass === proc
      @value_proc = proc
    end

    # CRUD method for create and update.
    def store(key, value)
      #super(cast_key(key), cast_value(value))
      super(key, cast_value(value))
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

  private

    #
    # Cast a given +hash+ according to the `#key_proc` and `#value_proc`.
    #
    # @param [#each] hash
    #
    def cast(hash)
      h = {}
      hash.each do |k,v|
        h[cast_key(k)] = cast_value(v)
      end
      h
    end

    #
    def cast_value(value)
      @value_proc ? @value_proc.call(value) : value
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
