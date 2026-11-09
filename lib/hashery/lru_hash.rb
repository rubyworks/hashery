module Hashery

  # Hash with LRU expiry policy.  There are at most max_size elements in a
  # LRUHash.  When adding more elements old elements are removed according
  # to LRU policy.
  #
  # Reading an entry with #[], #fetch, #assoc, #rassoc, #key or #values_at
  # marks it as the most recently used. Membership checks (#has_key?,
  # #has_value?) and iteration do not.
  #
  # Iteration (#each, #keys, #values, etc.) runs from the most recently used
  # entry to the least recently used one.
  #
  # The optional #release_proc is called with the key and value of every
  # entry that leaves the hash, whether evicted, deleted or cleared.
  # It is not called when a value is overwritten.
  #
  # An LRUHash is not thread-safe. Guard it with a Mutex if it is shared
  # between threads.
  #
  # Based on Robert Klemme's LRUHash class.
  #
  # LRUHash, Copyright (c) 2010 Robert Klemme.
  #
  class LRUHash

    include Enumerable

    attr_reader :max_size

    attr_accessor :default
    attr_accessor :default_proc
    attr_accessor :release_proc

    #
    # Initialize new LRUHash instance.
    #
    # max_size      - Maximum number of entries. Must be a positive integer
    #                 (or something whose #to_i is).
    # default_value - Value returned by #[] for missing keys.
    # block         - Default procedure called with the hash and key for
    #                 missing keys, like Hash.new's block.
    #
    def initialize(max_size, default_value=nil, &block)
      @max_size     = normalize_max(max_size)
      @default      = default_value
      @default_proc = block

      # Maps each key to a [key, value] pair. Hash keeps insertion order,
      # so the first entry is the least recently used and the last entry
      # the most recently used. Moving an entry to the end is a delete
      # followed by a re-insert of the same pair.
      @table = {}
    end

    #
    # Make a dup or clone independent of the original.
    #
    def initialize_copy(source)
      super
      @table = {}
      source.instance_variable_get(:@table).each_value do |key, value|
        @table[key] = [key, value]
      end
    end

    #
    # Iterate over each pair, most recently used first.
    #
    def each_pair
      return enum_for(:each_pair) { size } unless block_given?

      @table.values.reverse_each do |key, value|
        yield [key, value]
      end

      self
    end

    #
    # Same as each pair.
    #
    alias each each_pair

    #
    # Iterate over each key, most recently used first.
    #
    def each_key
      return enum_for(:each_key) { size } unless block_given?

      @table.values.reverse_each do |key, _value|
        yield key
      end

      self
    end

    #
    # Iterate over each value, most recently used first.
    #
    def each_value
      return enum_for(:each_value) { size } unless block_given?

      @table.values.reverse_each do |_key, value|
        yield value
      end

      self
    end

    #
    # Size of the hash.
    #
    def size
      @table.size
    end

    alias length size

    #
    # Is the hash empty?
    #
    def empty?
      @table.empty?
    end

    #
    # Returns the value for the key, marking it most recently used. Like
    # Hash#fetch, a missing key yields to the block if given, otherwise
    # returns the default argument if given, otherwise raises KeyError.
    #
    def fetch(key, default_value=UNDEFINED)
      if (pair = @table.delete(key))
        @table[pair[0]] = pair
        return pair[1]
      end

      if block_given?
        unless UNDEFINED.equal?(default_value)
          warn 'block supersedes default value argument', uplevel: 1
        end
        yield key
      elsif !UNDEFINED.equal?(default_value)
        default_value
      else
        raise KeyError.new("key not found: #{key.inspect}", receiver: self, key: key)
      end
    end

    #
    # Returns the value for the key, marking it most recently used, or
    # the default if the key is missing.
    #
    def [](key)
      if (pair = @table.delete(key))
        @table[pair[0]] = pair
        pair[1]
      elsif @default_proc
        @default_proc[self, key]
      else
        default
      end
    end

    #
    # Keys, most recently used first.
    #
    def keys
      @table.keys.reverse!
    end

    #
    # Values, most recently used first.
    #
    def values
      list = @table.map { |_key, pair| pair[1] }
      list.reverse!
    end

    #
    # Does the hash contain the key? Does not affect LRU order.
    #
    def has_key?(key)
      @table.key?(key)
    end

    alias key? has_key?
    alias member? has_key?
    alias include? has_key?

    #
    # Does the hash contain the value (compared with #eql?)?
    # Does not affect LRU order.
    #
    def has_value?(value)
      @table.each_value do |pair|
        return true if value.eql?(pair[1])
      end

      false
    end

    alias value? has_value?

    #
    # Values for the given keys, as by #[].
    #
    def values_at(*key_list)
      key_list.map {|k| self[k]}
    end

    #
    # Returns [key, value] for the key, marking it most recently used,
    # or nil if missing.
    #
    def assoc(key)
      if (pair = @table.delete(key))
        @table[pair[0]] = pair
        [pair[0], pair[1]]
      end
    end

    #
    # Returns [key, value] for the most recently used entry whose value is
    # #eql? to the given value, marking it most recently used, or nil.
    #
    def rassoc(value)
      @table.values.reverse_each do |pair|
        if value.eql?(pair[1])
          @table.delete(pair[0])
          @table[pair[0]] = pair
          return [pair[0], pair[1]]
        end
      end

      nil
    end

    #
    # Returns the key for the given value, as by #rassoc.
    #
    def key(value)
      pair = rassoc(value) and pair.first
    end

    #
    # Store a value, marking it most recently used. If the hash is full
    # and the key is new, the least recently used entry is evicted first.
    #
    def store(key, value)
      if (pair = @table.delete(key))
        pair[1] = value
        @table[pair[0]] = pair
      else
        # same optimization as in Hash
        key = key.dup.freeze if String === key && !key.frozen?

        evict_oldest if @table.size >= max_size

        @table[key] = [key, value]
      end

      value
    end

    alias []= store

    #
    # Delete the entry, calling the release_proc. Returns the value, or,
    # if the key is missing, the result of the block if given, else nil.
    #
    def delete(key)
      if (pair = @table.delete(key))
        release(pair)
        pair[1]
      elsif block_given?
        yield key
      end
    end

    #
    # Delete every entry for which the block returns true, calling
    # the release_proc for each.
    #
    def delete_if
      return enum_for(:delete_if) { size } unless block_given?

      @table.values.reverse_each do |key, value|
        next unless yield(key, value)
        pair = @table.delete(key)
        release(pair) if pair
      end

      self
    end

    #
    # Change the maximum size, evicting least recently used entries
    # as needed.
    #
    def max_size=(limit)
      limit = normalize_max(limit)

      while size > limit
        evict_oldest
      end

      @max_size = limit
    end

    #
    # Remove all entries, least recently used first, calling the
    # release_proc for each.
    #
    def clear
      until empty?
        evict_oldest
      end

      self
    end

    #
    # String representation, like Hash#inspect, most recently used first.
    #
    def to_s
      to_h.inspect
    end

    alias inspect to_s

  private

    #
    # Remove the least recently used entry, returning its [key, value] pair.
    #
    def evict_oldest
      _key, pair = @table.shift
      raise "Cannot delete from empty hash" unless pair
      release(pair)
      pair
    end

    #
    # Call the release_proc, if any, for a removed [key, value] pair.
    #
    def release(pair)
      release_proc and release_proc[pair[0], pair[1]]
    end

    #
    # Normalize the argument in order to be usable as max_size
    # criterion is that n.to_i must be an Integer and it must
    # be larger than zero.
    #
    # n - [#to_i] max size
    #
    def normalize_max(n)
      i = n.to_i
      raise ArgumentError, 'Invalid max_size: %p' % [n] unless Integer === i && i > 0
      i
    end

    # Marker for an omitted argument.
    UNDEFINED = Object.new.freeze
    private_constant :UNDEFINED

  end

end
