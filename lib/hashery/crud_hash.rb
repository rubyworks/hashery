require 'hashery/core_ext'

module Hashery

  # The CRUDHash is essentailly the same as the Hash class, but it reduces the 
  # the set of necessary methods to the fundametal CRUD requirements. All other
  # methods route through these CRUD methods. This is a better general design,
  # although it is, of course, a little bit slower. The utility of this class
  # becomes appearent when subclassing or delegating, as only a handful of methods
  # need to be changed for all other methods to work accordingly.
  #
  # In addition to the CRUD features, CRUDHash supports a `#key_proc`, akin to
  # `#default_proc`, that can be used to normalize keys.
  #
  class CRUDHash < ::Hash

    #
    # This method is overridden to ensure that new entries pass through
    # the `#store` method.
    #
    #
    def self.[](*hash)
      h = new
      super(*hash).each{ |k,v| h.store(k, v) }
      h
    end

    #
    # Alternate to #new which auto-creates sub-dictionaries as needed.
    # By default the `default_proc` procuced a empty Hash and is 
    # self-referential so every such Hash also has the same `default_proc`.
    #
    # args  - Pass-thru arguments to `#new`.
    # block - Alternate internal procedure for default proc.
    #
    # Examples
    #
    #   d = CRUDHash.auto
    #   d["a"]["b"]["c"] = "abc"  #=> { "a"=>{"b"=>{"c"=>"abc"}}}
    #
    # Returns `Hash`.
    #
    def self.auto(*args, &block)
      if block
        leet = lambda { |hsh, key| hsh[key] = block.call(hsh, key) }
      else
        leet = lambda { |hsh, key| hsh[key] = new(&leet) }
      end
      new(*args, &leet)
    end

    #
    # Set `key_proc`.
    #
    # Examples
    #
    #   ch = CRUDHash.new
    #   ch.key_proc = Proc.new{ |key| key.to_sym }
    #
    # Returns `Proc`.
    #
    def key_proc=(proc)
      raise ArgumentError unless Proc === proc or NilClass === proc
      @key_proc = proc
    end

    #
    # Get/set `key_proc`.
    #
    # Examples
    #
    #   ch = CRUDHash.new
    #   ch.key_proc
    #
    # Returns `Proc`.
    #
    def key_proc(&block)
      @key_proc = block if block
      @key_proc
    end

    #
    # Allow `#default_proc` to take a block.
    #
    # block - The `Proc` object to set the `default_proc`.
    #
    # Returns `Proc`, the `default_proc`.
    #
    def default_proc(&block)
      self.default_proc = block if block
      super()
    end

    #
    # CRUD method for checking if key exists.
    #
    # key - Hash key to lookup.
    #
    # Returns `true/false`.
    #
    def key?(key)
      super cast_key(key)
    end

    #
    # CRUD method for reading value.
    #
    # key - Hash key to lookup.
    #
    # Returns value of Hash entry.
    #
    def read(key)
      super cast_key(key)
    end

    #
    # CRUD method for create and update.
    #
    # key   - The `Object` to act as indexing key.
    # value - The `Object` to associate with key.
    #
    # Returns +value+.
    #
    def store(key, value)
      super(cast_key(key), value)
    end

    #
    # CRUD method for delete.
    #
    # key - Hash key to remove.
    #
    # Returns value of deleted Hash entry.
    #
    def delete(key)
      super cast_key(key)
    end

    #
    # Like #read but raises an error if key is not present.
    #
    # key - Hash key to lookup.
    #
    # Returns the `Object` that is the Hash entry's value.
    #
    def fetch(key)
      raise KeyError, "key not found: #{key.inspect}" unless key?(key)
      read key
    end

    #
    # Update Hash with +assoc+.
    #
    # assoc - Two-element `Array` or a `Hash`.
    #
    # Returns +assoc+.
    #
    def <<(assoc)
      case assoc
      when Hash
        update(assoc)
      when Array
        assoc.each_slice(2) do |(k,v)|
          store(k,v)
        end
      else
        raise ArgumentError  # or TypeError ?
      end
    end

    #
    # Operator for `#read`.
    #
    # key - Index key to lookup.
    #
    # Returns `Object` value of key.
    #
    def [](key)
      #if key?(key)
      #  fetch(key)
      #elsif default_proc
      #  default_proc.call(self, key)
      #else
      #  default
      #end
      read(key)
    end

    #
    # Operator for `#store`.
    #
    # key   - The `Object` to act as indexing key.
    # value - The `Object` to associate with key.
    #
    # Returns +value+.
    #
    def []=(key,value)
      store(key,value)
    end

    #
    # Update the Hash with another hash.
    # 
    # other - Other hash or hash-like object to add to the hash.
    #
    # Returns +self+.
    #
    def update(other)
      other.each do |k,v|
        store(k, v)
      end
      self
    end

    #
    # Alias for `#update`.
    #
    alias merge! update

    #
    # Merge the Hash with another hash, returning a new Hash.
    # 
    # other - Other hash or hash-like object to add to the hash.
    #
    # Returns `Hash`.
    #
    def merge(other)
      #super(other.rekey{ |key| cast_key(key) })
      copy = dup
      other.each{ |k,v| copy.store(k, v) }
      copy
    end

    #
    # Iterate over each hash pair.
    #
    def each #:yield:
      if block_given?
        keys.each do |k|
          yield(k, read(k))
        end
      else
        to_enum(:each)
      end
    end

    #
    # Alias for #each.
    #
    alias each_pair each

    #
    # Alias for `#key?`.
    #
    alias has_key? key?

    #
    # Alias for `#key?`.
    #
    alias member? key?

    #
    # Alias for `#key?`.
    #
    alias include? key?   # why isn't it an alias for `#has_value?` ?

    #
    # Replace current entries with those from another Hash,
    # or Hash-like object. Each entry is run through the
    # casting procedure as it is added.
    #
    # other - Hash-like object.
    #
    # Returns +self+.
    # 
    def replace(other)
      super cast(other)
   end

    #
    # Get the values at.
    #
    # keys - List of keys to lookup.
    #
    # Returns `Array` of values.
    #
    def values_at(*keys)
      super *keys.map{ |key| cast_key(key) }
    end

    # Convert CRUDHash to regular Hash.
    #
    # TODO: Since a CRUDHash is a subclass of Hash should #to_hash just `#dup`
    #       insted of converting to traditional Hash?
    #
    def to_hash
      h = {}; each{ |k,v| h[k] = v }; h
    end #unless method_defined?(:to_hash)

    #
    # Convert CRUDHash to regular Hash.
    #
    # TODO: Since a CRUDHash is a subclass of Hash should #to_h just `#dup`
    #       insted of converting to traditional Hash?
    #
    # Returns `Hash`.
    #
    alias :to_h :to_hash

  private

    #
    # Cast a given `hash` in accordance to the `#key_proc`.
    #
    # hash - Any object the responds to `#each` like a Hash.
    #
    # Returns `Hash`.
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
    # key - Index key.
    #
    # Returns key after passing through the `key_proc`.
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
