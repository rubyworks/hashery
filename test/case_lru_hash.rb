require 'helper'

test_case LRUHash do

  # Build a full hash of :a => 1, :b => 2, :c => 3, used least recently
  # in that order, i.e. :a is next to be evicted.
  def abc(max_size=3)
    h = LRUHash.new(max_size)
    h[:a] = 1
    h[:b] = 2
    h[:c] = 3
    h
  end

  class_method :new do
    test do
      h = LRUHash.new(10)
      LRUHash.assert === h
    end

    test "max_size is converted with #to_i" do
      LRUHash.new("5").max_size.assert == 5
      LRUHash.new(2.9).max_size.assert == 2
    end

    test "max_size must be positive" do
      ArgumentError.assert.raised? { LRUHash.new(0) }
      ArgumentError.assert.raised? { LRUHash.new(-1) }
      ArgumentError.assert.raised? { LRUHash.new(nil) }
    end

    test "default value" do
      h = LRUHash.new(10, :none)
      h[:x].assert == :none
    end
  end

  method :max_size= do
    test do
      h = LRUHash.new(10)
      h.max_size = 100
      h.max_size.assert == 100
    end

    test "shrinking evicts least recently used entries" do
      h = abc
      h[:a]
      h.max_size = 1
      h.keys.assert == [:a]
    end
  end

  method :store do
    test do
      h = LRUHash.new(10)
      h.store(:a, 1)
      h[:a].assert == 1
    end

    test "returns the value" do
      h = LRUHash.new(10)
      h.store(:a, 1).assert == 1
    end

    test "evicts the least recently used entry when full" do
      h = abc
      h.store(:d, 4)
      h.keys.assert == [:d, :c, :b]
    end

    test "overwriting a key does not evict" do
      h = abc
      h.store(:a, 10)
      h.size.assert == 3
      h.keys.assert == [:a, :c, :b]
      h[:a].assert == 10
    end

    test "unfrozen String keys are copied and frozen" do
      h = LRUHash.new(10)
      k = String.new("k")
      h.store(k, 1)
      k << "x"
      h.keys.assert == ["k"]
      h.keys.first.assert.frozen?
    end
  end

  method :[] do
    test do
      h = LRUHash.new(10)
      h.store(:a, 1)
      h[:a].assert == 1
    end

    test do
      h = LRUHash.new(10){ |h,k| h[k] = 0 }
      h[:a].assert == 0
    end

    test "marks the entry most recently used" do
      h = abc
      h[:a]
      h[:d] = 4
      h.keys.assert == [:d, :a, :c]
    end

    test "nil values are found" do
      h = LRUHash.new(10, :default)
      h[:a] = nil
      h[:a].assert == nil
    end
  end

  method :fetch do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h.fetch(:a).assert == 1
    end

    test "missing key raises KeyError" do
      h = LRUHash.new(10)
      KeyError.assert.raised? { h.fetch(:x) }
    end

    test "KeyError names the key and receiver" do
      h = LRUHash.new(10)
      e = (h.fetch(:x) rescue $!)
      KeyError.assert === e
      e.message.assert == "key not found: :x"
      e.key.assert == :x
      e.receiver.assert.equal?(h)
    end

    test "missing key with block" do
      h = LRUHash.new(10)
      h.fetch(:x){ |k| "no #{k}" }.assert == "no x"
    end

    test "missing key with default argument" do
      h = LRUHash.new(10)
      h.fetch(:x, 0).assert == 0
      h.fetch(:x, nil).assert == nil
    end

    test "ignores the hash default" do
      h = LRUHash.new(10, :default)
      KeyError.assert.raised? { h.fetch(:x) }
    end

    test "marks the entry most recently used" do
      h = abc
      h.fetch(:a)
      h[:d] = 4
      h.keys.assert == [:d, :a, :c]
    end
  end

  method :empty? do
    test do
      h = LRUHash.new(10)
      h.assert.empty?
    end
  end

  method :size do
    test do
      abc.size.assert == 3
      abc.length.assert == 3
    end
  end

  method :key do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h.key(1).assert == :a
    end
  end

  method :keys do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h.keys.assert == [:a]
    end

    test "most recently used first" do
      h = abc
      h[:a]
      h.keys.assert == [:a, :c, :b]
    end
  end

  method :values do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h.values.assert == [1]
    end

    test "most recently used first" do
      h = abc
      h[:a]
      h.values.assert == [1, 3, 2]
    end
  end

  method :values_at do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h[:b] = 2
      h.values_at(:a).assert == [1]
    end

    test "missing keys give the default" do
      h = LRUHash.new(10, :none)
      h[:a] = 1
      h.values_at(:a, :x).assert == [1, :none]
    end
  end

  method :has_key? do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h.assert.has_key?(:a)
      h.assert.key?(:a)
      h.assert.member?(:a)
      h.assert.include?(:a)
      h.refute.has_key?(:b)
    end

    test "does not affect LRU order" do
      h = abc
      h.has_key?(:a)
      h[:d] = 4
      h.refute.has_key?(:a)
    end
  end

  method :has_value? do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h.assert.has_value?(1)
      h.refute.has_value?(2)
    end
  end

  method :assoc do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h[:b] = 2
      h.assoc(:a).assert == [:a,1]
      h.assoc(:x).assert == nil
    end
  end

  method :rassoc do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h[:b] = 2
      h.rassoc(1).assert == [:a,1]
      h.rassoc(9).assert == nil
    end
  end

  method :each do
    test "most recently used first" do
      h = abc
      h[:a]
      h.to_a.assert == [[:a, 1], [:c, 3], [:b, 2]]
    end

    test "returns an enumerator without a block" do
      Enumerator.assert === abc.each
      abc.each.size.assert == 3
    end

    test "allows modification while iterating" do
      h = abc
      h.each { |k, v| h[k] = v * 10 }
      h.values.sort.assert == [10, 20, 30]
    end
  end

  method :each_key do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h[:b] = 2
      h.each_key do |k|
        [:a,:b].assert.include?(k)
      end
    end
  end

  method :each_value do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h[:b] = 2
      h.each_value do |v|
        [1,2].assert.include?(v)
      end
    end
  end

  method :clear do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h[:b] = 2
      h.clear
      h.assert.empty?
    end
  end

  method :delete do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h.delete(:a).assert == 1
      h.assert.empty?
    end

    test "missing key returns nil" do
      h = LRUHash.new(10)
      h.delete(:a).assert == nil
    end

    test "missing key with block" do
      h = LRUHash.new(10)
      h.delete(:a){ |k| "no #{k}" }.assert == "no a"
    end
  end

  method :delete_if do
    test do
      h = LRUHash.new(10)
      h[:a] = 1
      h.delete_if{ |k,v| k == :a }
      h.assert.empty?
    end

    test "returns self" do
      h = abc
      h.delete_if{ |k,v| v.odd? }.assert.equal?(h)
      h.keys.assert == [:b]
    end

    test "returns an enumerator without a block" do
      Enumerator.assert === abc.delete_if
    end
  end

  method :release_proc= do
    test "called for evicted, deleted and cleared entries" do
      log = []
      h = LRUHash.new(2)
      h.release_proc = lambda { |k, v| log << [k, v] }
      h[:a] = 1
      h[:b] = 2
      h[:c] = 3          # evicts :a
      h.delete(:b)
      h[:d] = 4
      h.clear            # least recently used first
      log.assert == [[:a, 1], [:b, 2], [:c, 3], [:d, 4]]
    end

    test "called when shrinking and in delete_if" do
      log = []
      h = abc
      h.release_proc = lambda { |k, v| log << k }
      h.max_size = 2
      h.delete_if { |k, v| k == :c }
      log.assert == [:a, :c]
    end

    test "not called when a value is overwritten" do
      log = []
      h = LRUHash.new(2)
      h.release_proc = lambda { |k, v| log << k }
      h[:a] = 1
      h[:a] = 2
      log.assert == []
    end
  end

  method :dup do
    test "copy is independent of the original" do
      a = abc
      b = a.dup
      b[:d] = 4
      b.delete(:b)
      a.to_a.assert == [[:c, 3], [:b, 2], [:a, 1]]
      b.to_a.assert == [[:d, 4], [:c, 3]]
    end

    test "copy keeps LRU order" do
      a = abc
      a[:a]
      a.dup.keys.assert == [:a, :c, :b]
    end
  end

  method :inspect do
    test "looks like a Hash, most recently used first" do
      h = LRUHash.new(10)
      h[:a] = "x"
      h[nil] = 1
      h.inspect.assert == {nil => 1, :a => "x"}.inspect
      h.to_s.assert == h.inspect
    end

    test "empty" do
      LRUHash.new(10).inspect.assert == "{}"
    end
  end

  method :to_h do
    test do
      abc.to_h.assert == {:a => 1, :b => 2, :c => 3}
    end
  end

end
