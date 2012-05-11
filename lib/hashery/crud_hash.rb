require 'hashery/core_ext'

module Hashery

  # The CRUDHash is essentailly the same as the Hash class, but it reduces the 
  # the set of necessary methods ot the fundametal CRUD requirements. All other
  # methods route through these CRUD methods. This is a better general design,
  # although it is, of course, a little bit slower. The utility of this class
  # becomes appearent when subclassing or delegating, as only a handful of methods
  # need to be changed for all other methods to work accordingly.
  #
  # In addition to the CRUD features, CRUDHash supports a `#key_proc`, akin to
  # `#default_proc`, that can be used to normalize keys.
  #
  class CRUDHash << ::Hash

    #
    # @example
    #   ch = CRUDHash.new
    #   ch.key_proc = Proc.new{ |key| key.to_sym }
    #
    def key_proc=(proc)
      raise ArgumentError unless Proc === proc or NilClass === proc
      @key_proc = proc
    end

    #
    # @example
    #   ch = CRUDHash.new
    #   ch.key_proc
    #
    def key_proc(&block)
      @key_proc = block if block
      @key_proc
    end

    # CRUD method for checking if key exists.
    def key?(key)
      super cast_key(key)
    end

    # CRUD method for reading value.
    def fetch(key)
      super cast_key(key)
    end

    # CRUD method for create and update.
    def store(key, value)
      self[cast_key(key)] = value
    end

    # CRUD method for delete.
    def delete(key)
      super cast_key(key)
    end

    #
    def <<(x)
      case x
      when Hash
        update(x)
      when Array
        x.each_slice(2) do |(k,v)|
          store(k,v)
        end
      else
        raise ArgumentError  # or TypeError ?
      end
    end

    #
    def [](key)
      key?(key) ? fetch(key) : nil
    end

    #
    def []=(key,value)
      store(key,value)
    end

    #
    def update(other)
      other.each do |k,v|
        store(k, v)
      end
    end

    #
    alias merge! update

    #
    def merge(other)
      #super(other.rekey{ |key| cast_key(key) })
      copy = dup
      other.each{ |k,v| copy.store(k, v) }
      copy
    end

    #
    def each #:yield:
      each do |k,v|
        yield(k, v)
      end
    end
    alias each_pair each

    #
    alias has_key? key?
    alias member? key?
    alias include? key?   # why isn't it an alias for `#has_value?` ?

    #
    def replace(other)
      super cast(other)
    end

    #
    def values_at(*keys)
      super *keys.map{ |key| cast_key(key) }
    end

    #
    # @todo Should CRUDHash#to_h duplicate or just return `self`?
    def to_h
      dup
    end unless method_defined?(:to_h)

    #
    # @todo Should CRUDHash#to_hash convert to traditional hash?
    def to_hash
      dup
    end unless method_defined?(:to_hash)

  private

    # Cast a given +hash+ in accordance to the `#key_proc`.
    #
    # @param [#each] hash
    #
    def cast(hash)
      h = {}
      hash.each do |k,v|
        h[cast_key(k)] = v
      end
      h
    end

    #
    # Callback for normalizing hash keys.
    #
    def cast_key(key)
      @key_proc ? @key_proc.call(key) : key
    end

    # TODO: Consider value callback procs for future version of CRUDHash.
    #
    #    #
    #    # Callback for writing value.
    #    #
    #    def cast_write(value)
    #      @write_proc ? @write_proc.call(value) : value
    #    end
    #
    #    #
    #    # Callback for reading value.
    #    #
    #    def cast_read(value)
    #      @read_proc ? @read_proc.call(value) : value
    #    end

  end

end
