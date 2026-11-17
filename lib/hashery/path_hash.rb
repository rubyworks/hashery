module Hashery

  # A PathHash is a hash whose values can be accessed in the normal manner,
  # or with keys that are slash (`/`) separated strings. To get the whole hash
  # as a single flattened level, call `#flat`. All keys are converted to strings.
  # All end-of-the-chain values are kept in whatever value they are.
  #
  #   s = PathHash['a' => 'b', 'c' => {'d' => :e}]
  #   s['a'] #=> 'b'
  #   s['c'] #=> {slashed: 'd'=>:e}
  #   s['c']['d'] #=> :e
  #   s['c/d'] #=> :e
  #
  # PathHash is derived from the SlashedHash class in the HashMagic project
  # by Daniel Parker <gems@behindlogic.com>.
  #   
  # Copyright (c) 2006 BehindLogic (http://hash_magic.rubyforge.org)
  #
  # Authors: Daniel Parker
  #
  # TODO: This class is very much a work in progess and will be substantially rewritten
  # for future versions.
  #
  class PathHash < Hash

    #
    # Create a PathHash from a Hash, or from key-value pairs as Hash[] takes.
    #
    def self.[](*args)
      new(Hash[*args])
    end

    #
    # Initialize PathHash.
    #
    # hsh - Priming Hash.
    #
    def initialize(hsh={})
      raise ArgumentError, "must be a hash or array of slashed values" unless hsh.is_a?(Hash) || hsh.is_a?(Array)
      hsh = hsh.expand if hsh.is_a?(PathHash)
      @constructor = hsh.is_a?(Hash) ? hsh.class : Hash
      @flat = flatten_to_hash(hsh)
    end

    #
    # Copies get their own table, so changing one doesn't change the other.
    #
    def initialize_copy(source)
      super
      @flat = @flat.dup
    end

    # Standard Hash methods, plus the overwritten ones
    #include StandardHashMethodsInRuby

    # Behaves like the usual Hash#[] method, but you can access nested hash
    # values by composing a single key of the traversing keys joined by '/':
    #
    #   hash['c']['d'] # is the same as:
    #   hash['c/d']
    #
    def [](key)
      key = key.to_s
      return @flat[key] if @flat.has_key?(key)
      sub = subtree(key)
      sub.empty? ? nil : self.class.new(sub)
    end

    #
    # Same as above, except sets value rather than retrieving it.
    #
    def []=(key,value)
      key = key.to_s
      @flat.reject! {|k,v| under?(k, key)}
      if value.is_a?(Hash)
        flatten_to_hash(value).each do |hk,hv|
          @flat[key.to_s+'/'+hk.to_s] = hv
        end
      else
        @flat[key.to_s] = value
      end
    end

    def clear # :nodoc:
      @flat.clear
      self
    end

    #
    # Like Hash#fetch, but slashed keys can be used here, too.
    #
    def fetch(key,default=:ehisehoah0928309q98y30,&block) # :nodoc:
      key = key.to_s
      return @flat[key] if @flat.has_key?(key)
      sub = subtree(key)
      return self.class.new(sub) unless sub.empty?
      return block.call(key) if block
      return default unless default == :ehisehoah0928309q98y30
      raise KeyError, "key not found: #{key.inspect}"
    end

    #
    # Delete entry from Hash. Slashed keys can be used here, too.
    #
    # key   - The key to delete.
    # block - Produces the return value if key not found.
    #
    # Returns delete value.
    #
    def delete(key,&block)
      key = key.to_s
      return block ? block.call(key) : nil unless key?(key)
      value = self[key]
      @flat.delete_if {|k,v| under?(k, key)}
      return value
    end

    #
    def empty?
      @flat.empty?
    end

    #
    # Is there a value at this key, or below it? Slashed keys can be used.
    #
    def key?(key)
      key = key.to_s
      @flat.any? {|k,v| under?(k, key)}
    end
    alias_method :has_key?, :key?
    alias_method :include?, :key?
    alias_method :member?, :key?

    # This gives you the slashed key of the value, no matter where the value is in the tree.
    def key(value)
      @flat.key(value)
    end
    alias_method :index, :key

    #
    # Iterate over the top-level keys and their values, as #[] gives them.
    #
    def each
      return to_enum(:each) { size } unless block_given?
      keys.each {|k| yield k, self[k]}
      self
    end
    alias_method :each_pair, :each

    #
    # The number of top-level keys.
    #
    def size
      keys.size
    end
    alias_method :length, :size

    #
    # The values of the top-level keys, as #[] gives them.
    #
    def values
      keys.map {|k| self[k]}
    end

    #
    def to_a
      keys.map {|k| [k, self[k]]}
    end

    #
    def inspect
      @flat.inspect.insert(1,'slashed: ')
    end

    # This gives you only the top-level keys, no slashes. To get the list of slashed keys, do hash.flat.keys
    def keys
      @flat.inject([]) {|a,(k,v)| a << [k.split('/',2)].flatten[0]; a}.uniq
    end

    # This is rewritten to mean something slightly different than usual: Use this to restructure the hash, for cases when you
    # end up with an array holding several hashes.
    def rehash # :nodoc:
      @flat.rehash
      self
    end

    # Gives a list of all keys in all levels in the multi-level hash, joined by slashes.
    #
    #   {'a'=>{'b'=>'c', 'c'=>'d'}, 'b'=>'c'}.slashed.flat.keys
    #   #=> ['a/b', 'a/c', 'b']
    #
    def flat
      @flat
    end

    # Expands the whole hash to Hash objects ... not useful very often, it seems.
    def expand
      keys.inject({}) {|h,k| v = self[k]; h[k] = v.is_a?(PathHash) ? v.expand : v; h}
    end
    alias_method :to_h, :expand

    def to_string_array
      flatten_to_array(flat,[])
    end

    def slashed # :nodoc:
      self
    end

    # Same as ordered! but returns a new PathHash object instead of modifying the same.
    def ordered(*keys_in_order)
      dup.ordered!(*keys_in_order)
    end

    # Puts the entries in the given order. The *keys_in_order must be a flat
    # array of slashed keys that specify the order for each level; entries
    # not named keep their order, after those that are:
    #
    #   s = PathHash['a'=>{'b'=>'c', 'c'=>'d'}, 'b'=>'c']
    #   s.ordered!('b', 'a/c', 'a/b')
    #   s.expand # => {'b'=>'c', 'a'=>{'c'=>'d', 'b'=>'c'}}
    #
    def ordered!(*keys_in_order)
      ordered = @flat.class.new
      keys_in_order.each do |key|
        key = key.to_s
        @flat.each {|k,v| ordered[k] = v if under?(k, key) && !ordered.has_key?(k)}
      end
      @flat.each {|k,v| ordered[k] = v unless ordered.has_key?(k)}
      @flat = ordered
      self
    end

    #
    # A PathHash equals another with the same entries, or a Hash that would
    # make one.
    #
    def ==(other)
      case other
      when PathHash
        @flat == other.flat
      when Hash
        self == PathHash.new(other)
      else
        false
      end
    end

    private

      # Is the flat key +k+ the key +key+, or below it?
      def under?(k, key)
        k == key || k.start_with?(key + '/')
      end

      # The entries below +key+, with +key+ taken off the front of their keys.
      def subtree(key)
        prefix = key + '/'
        @flat.each_with_object(@constructor.new) do |(k,v),h|
          h[k[prefix.size..-1]] = v if k.start_with?(prefix)
        end
      end

      def flatten_to_hash(hsh, flat=@constructor.new)
        if hsh.is_a?(Array)
          hsh.each do |e|
            if e.is_a?(Hash) || e.is_a?(Array)
              flat.merge!(flatten_to_hash(e))
            else
              flatten_to_hash(e, flat)
            end
          end
        elsif hsh.is_a?(Hash)
          hsh.each do |k,v|
            if v.is_a?(Hash)
              flatten_to_hash(v).each do |hk,hv|
                flat[k.to_s+'/'+hk.to_s] = hv
              end
            else
              flat[k.to_s] = v
            end
          end
        else
          ks = hsh.split('/',-1)
          v = ks.pop
          ks = ks.join('/')
          if !flat[ks].nil?
            if flat[ks].is_a?(Array)
              flat[ks] << v
            else
              flat[ks] = [flat[ks], v]
            end
          else
            flat[ks] = v
          end
        end
        flat
      end

      def flatten_to_array(value,a)
        if value.is_a?(Array)
          value.each {|e| flatten_to_array(e,a)}
        elsif value.is_a?(Hash)
          value.inject([]) {|aa,(k,v)| flatten_to_array(v,[]).each {|vv| aa << k+'/'+vv.to_s}; aa}.each {|e| a << e}
        else
          a << value.to_s
        end
        a
      end
  end

end
