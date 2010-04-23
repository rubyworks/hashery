# = StaticHash
#
# A Hash object which raises an error if any
# previously-defined key attempts to be set again.
#
# == Synopsis
#
#   foo = Hash::Static.new
#   foo['name'] = 'Tom'    #=> 'Tom'
#   foo['age']  = 30       #=> 30
#   foo['name'] = 'Bob'
#
# _produces_
#
#   ArgumentError: Duplicate key for StaticHash -- 'name'
#
# == Credit
#
# StaticHash has it's orgins in Gavin Kistner's WriteOnceHash
# class found in his +basiclibrary.rb+ script.

class StaticHash < Hash

  # Set a value for a key. Raises an error if that key already
  # exists with a different value.

  def []=(key, value)
    if key?(key) && self[key] != value
      raise ArgumentError, "Duplicate key for StaticHash -- #{key.inspect}"
    end
    super(key, value)
  end

  #
  def update(hash)
    dups = (keys | hash.keys)
    if dups.empty?
      super(hash)
    else
      raise ArgumentError, "Duplicate key for StaticHash -- #{dups.inspect}"
    end
  end

  #
  alias_method :merge!, :update

end

