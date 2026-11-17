require 'helper'
require 'hashery/path_hash'

test_case PathHash do

  class_method :[] do
    test "makes a PathHash from a Hash" do
      s = PathHash['a' => 'b', 'c' => {'d' => :e}]
      s.flat.assert == {'a' => 'b', 'c/d' => :e}
    end
  end

  class_method :new do
    test "flattens nested hashes" do
      s = PathHash.new('a' => 'b', 'c' => {'d' => :e})
      s.flat.assert == {'a' => 'b', 'c/d' => :e}
    end

    test "collects slashed values from an array" do
      s = PathHash.new(['a/b', 'a/c'])
      s.flat.assert == {'a' => ['b', 'c']}
    end

    test "copies another PathHash" do
      s = PathHash.new('c' => {'d' => :e})
      PathHash.new(s).flat.assert == {'c/d' => :e}
    end
  end

  method :[] do
    test "reads top-level and slashed keys" do
      s = PathHash['a' => 'b', 'c' => {'d' => :e}]
      s['a'].assert == 'b'
      s['c/d'].assert == :e
      s['c']['d'].assert == :e
      s['c'].assert.is_a?(PathHash)
    end

    test "returns nil for a missing key" do
      PathHash['a' => 1]['x'].assert == nil
    end

    test "doesn't match keys that only start the same" do
      s = PathHash['ab' => 1, 'a' => {'b' => 2}]
      s['a'].flat.assert == {'b' => 2}
    end

    test "takes keys literally, not as patterns" do
      s = PathHash['a.b' => 1, 'axb' => {'c' => 2}]
      s['a.b'].assert == 1
    end

    test "converts keys to strings" do
      PathHash['a' => 1][:a].assert == 1
    end
  end

  method :[]= do
    test "stores with a slashed key" do
      s = PathHash.new
      s['a/b'] = 1
      s['a']['b'].assert == 1
    end

    test "flattens a Hash value" do
      s = PathHash.new
      s['a'] = {'b' => 1}
      s.flat.assert == {'a/b' => 1}
    end

    test "replaces what was below the key" do
      s = PathHash['a' => {'b' => 1}]
      s['a'] = 2
      s.flat.assert == {'a' => 2}
    end
  end

  method :fetch do
    test "reads slashed keys" do
      s = PathHash['c' => {'d' => {'e' => 1}}]
      s.fetch('c/d/e').assert == 1
      s.fetch('c/d').flat.assert == {'e' => 1}
    end

    test "returns the default or the block's value for a missing key" do
      s = PathHash['a' => 1]
      s.fetch('x', 0).assert == 0
      s.fetch('x'){ |k| k * 2 }.assert == 'xx'
    end

    test "raises KeyError for a missing key" do
      KeyError.assert.raised? do
        PathHash['a' => 1].fetch('x')
      end
    end
  end

  method :delete do
    test "removes a key and what is below it" do
      s = PathHash['a' => 1, 'c' => {'d' => 2}]
      s.delete('c').flat.assert == {'d' => 2}
      s.flat.assert == {'a' => 1}
    end

    test "returns nil, or the block's value, for a missing key" do
      s = PathHash['a' => 1]
      s.delete('x').assert == nil
      s.delete('x'){ |k| "no #{k}" }.assert == 'no x'
    end
  end

  method :key? do
    test "finds top-level and slashed keys" do
      s = PathHash['a' => 1, 'c' => {'d' => 2}]
      s.assert.key?('a')
      s.assert.key?('c')
      s.assert.key?('c/d')
      s.refute.key?('x')
      s.refute.key?('c/x')
    end
  end

  method :key do
    test "gives the slashed key of a value" do
      PathHash['c' => {'d' => :e}].key(:e).assert == 'c/d'
    end
  end

  method :index do
    test "is the same as key" do
      PathHash['c' => {'d' => :e}].index(:e).assert == 'c/d'
    end
  end

  method :keys do
    test "lists the top-level keys" do
      PathHash['a' => 1, 'c' => {'d' => 2, 'e' => 3}].keys.assert == ['a', 'c']
    end
  end

  method :size do
    test "counts the top-level keys" do
      PathHash['a' => 1, 'c' => {'d' => 2, 'e' => 3}].size.assert == 2
    end
  end

  method :each do
    test "yields the top-level keys and their values" do
      s = PathHash['a' => 1, 'c' => {'d' => 2}]
      pairs = []
      s.each{ |k, v| pairs << [k, v] }
      pairs.map(&:first).assert == ['a', 'c']
      pairs[1][1].flat.assert == {'d' => 2}
    end

    test "returns an Enumerator without a block" do
      PathHash['a' => 1].each.to_a.assert == [['a', 1]]
    end
  end

  method :expand do
    test "gives back nested hashes" do
      h = {'a' => 'b', 'c' => {'d' => :e}}
      PathHash.new(h).expand.assert == h
    end
  end

  method :to_string_array do
    test "lists each value with its slashed key" do
      PathHash['a' => 'b', 'c' => {'d' => :e}].to_string_array.assert == ['a/b', 'c/d/e']
    end
  end

  method :ordered! do
    test "puts the entries in the given order" do
      s = PathHash['a' => {'b' => 'c', 'c' => 'd'}, 'b' => 'c']
      s.ordered!('b', 'a/c', 'a/b')
      s.expand.to_a.assert == [['b', 'c'], ['a', {'c' => 'd', 'b' => 'c'}]]
      s.expand['a'].keys.assert == ['c', 'b']
    end
  end

  method :ordered do
    test "orders a copy" do
      s = PathHash['a' => 1, 'b' => 2]
      s.ordered('b').keys.assert == ['b', 'a']
      s.keys.assert == ['a', 'b']
    end
  end

  method :== do
    test "compares entries" do
      s = PathHash['a' => 1, 'c' => {'d' => 2}]
      s.assert == PathHash['a' => 1, 'c' => {'d' => 2}]
      s.refute == PathHash['a' => 1]
    end

    test "compares with a Hash" do
      s = PathHash['a' => 1, 'c' => {'d' => 2}]
      s.assert == {'a' => 1, 'c' => {'d' => 2}}
    end

    test "is false for anything else" do
      PathHash['a' => 1].refute == 1
    end
  end

  method :dup do
    test "makes an independent copy" do
      s = PathHash['a' => 1]
      d = s.dup
      d['a'] = 2
      s['a'].assert == 1
    end
  end

  method :clear do
    test "removes everything" do
      s = PathHash['a' => 1]
      s.clear.assert.equal?(s)
      s.assert.empty?
    end
  end

end
