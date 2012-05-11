require 'lemon'
require 'ae'
require 'ae/legacy'

require 'hashery/basic_struct'

testcase BasicStruct do
  include AE::Legacy::Assertions

  method :respond_to? do
    test do
      o = BasicStruct.new
      t = o.respond_to?(:key?)
      assert t
    end
  end

  method :is_a? do
    test do
      assert BasicStruct[{}].is_a?(Hash)
      assert BasicStruct[{}].is_a?(BasicStruct)
    end
  end

  method :[] do
    test "subhash access" do
      o = BasicStruct[:a=>1,:b=>{:x=>9}]
      assert( o[:b][:x] == 9 )
      assert( o.b[:x] == 9 )
    end

    test "indifferent key access" do
      o = BasicStruct["a"=>1,"b"=>{:x=>9}]
      assert( o["a"] == 1 )
      assert( o[:a] == 1 )
      assert( o["b"] == {:x=>9} )
      assert( o[:b] == {:x=>9} )
      assert( o["b"][:x] == 9 )
      assert( o[:b]["x"] == nil )
    end
  end

  method :[]= do
    test "setting first entry" do
      f0 = BasicStruct.new
      f0[:a] = 1
      assert( f0.to_h == {:a=>1} )
    end

    test "setting an additional entry" do
      f0 = BasicStruct[:a=>1]
      f0[:b] = 2
      assert( f0.to_h == {:a=>1,:b=>2} )
    end
  end

  method :method_missing do
    test "reading entries" do
      f0 = BasicStruct[:class=>1]
      assert( f0.class  == 1 )
    end

    test "setting entries" do
      fo = BasicStruct.new
      9.times{ |i| fo.__send__("n#{i}=", 1) }
      9.times{ |i|
        assert( fo.__send__("n#{i}") == 1 )
      }
    end

    test "using bang" do
      o = BasicStruct.new
      o.a = 10
      o.b = 20
      h = {}
      o.each!{ |k,v| h[k] = v + 10 }
      assert( h == {:a=>20, :b=>30} )
    end
  end

  #method :as_hash do
  #  test do
  #    f0 = BasicStruct[:f0=>"f0"]
  #    h0 = { :h0=>"h0" }
  #    assert( BasicStruct[:f0=>"f0", :h0=>"h0"] == f0.as_hash.merge(h0) )
  #    assert(  {:f0=>"f0", :h0=>"h0"} == h0.merge(f0) )
  #  end
  #end

  method :as_hash do
    test do
      f1 = BasicStruct[:f1=>"f1"]
      h1 = { :h1=>"h1" }
      f1.as_hash.update(h1)
      assert( f1 == BasicStruct[:f1=>"f1", :h1=>"h1"] )
    end
  end

  #method :as_hash do
  #  test do
  #    f1 = BasicStruct[:f1=>"f1"]
  #    h1 = { :h1=>"h1" }
  #    f1.as_hash.update(h1)
  #    h1.update(f1)
  #    assert( f1 == BasicStruct[:f1=>"f1", :h1=>"h1"] )
  #    assert( h1 == {:f1=>"f1", :h1=>"h1"} )
  #  end
  #end

  method :<< do
    test "passing a hash" do
      fo = BasicStruct.new
      fo << {:a=>1,:b=>2}
      assert( fo.to_h == {:a=>1, :b=>2} )
    end

    test "passing a pair" do
      fo = BasicStruct.new
      fo << [:a, 1]
      fo << [:b, 2]
      assert( fo.to_h == {:a=>1, :b=>2} )
    end
  end

  method :to_h do
    test do
      ho = {}
      fo = BasicStruct.new
      5.times{ |i| ho["n#{i}".to_sym] = 1 }
      5.times{ |i| fo.__send__("n#{i}=", 1) }
      assert( fo.to_h == ho )
    end
    test "BasicStruct within BasicStruct" do
      o = BasicStruct.new
      o.a = 10
      o.b = 20
      o.x = BasicStruct.new
      o.x.a = 100
      o.x.b = 200
      o.x.c = 300
      assert( o.to_h == {:a=>10, :b=>20, :x=>{:a=>100, :b=>200, :c=>300}} )
    end
  end

  method :to_proc do
    test do
      #p = Proc.new{ |x| x.word = "Hello" }
      o = BasicStruct[:a=>1,:b=>2]
      assert( Proc === o.to_proc )
    end
  end

end

TestCase Hash do

  method :to_basicstruct do
    test do
      h = {'a'=>1, 'b'=>2}
      o = h.to_basicstruct
      assert( o.a == 1 )
      assert( o.b == 2 )
    end
  end

  method :update do
    test "by BasicStruct" do
      raise NotImplementedError, "Ruby 1.8 does not know #to_hash."

      h1 = { :h1=>"h1" }
      f1 = BasicStruct[:f1=>"f1"]
      h1.update(f1)
      assert( h1 == {:f1=>"f1", :h1=>"h1"} )
    end
  end

end

=begin
TestCase Proc do

  method :to_basicstruct do
    test do
      p = lambda { |x| x.word = "Hello" }
      o = p.to_basicstruct
      assert( o.word == "Hello" )
    end
  end

end
=end

