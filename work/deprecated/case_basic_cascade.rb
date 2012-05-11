require 'lemon'
require 'ae'
require 'ae/legacy' # bacause imitation BasicObject sucks

require 'hashery/basic_cascade'

testcase BasicCascade do
  include AE::Legacy::Assertions

  class_method :new do
    BasicCascade.new(:a=>1)
  end

  class_method :[] do
    test "hash" do
      o = BasicCascade[:a=>1,:b=>2]
      assert_equal(1, o.a)
      assert_equal(2, o.b)
    end
    test "hash in hash" do
      o = BasicCascade[:a=>1,:b=>2,:c=>{:x=>9}]
      assert_equal(9, o.c.x)
    end
    test "hash in hash in hash" do
      h = {:a=>1,:x=>{:y=>{:z=>1}}}
      c = BasicCascade[h]
      assert_equal(1, c.x.y.z)
    end
  end

  method :[] do
    test "basic assignment" do
      o = BasicCascade.new
      o[:a] = 1
      assert_equal(1, o.a)
    end
  end

  method :[]= do
    test "basic assignment with primed BasicCascade" do
      o = BasicCascade[:a=>1]
      o[:b] = 2
      o.to_h.assert == {:a=>1,:b=>2}
    end
  end

  method :to_a do
    test do
      o = BasicCascade[:a=>1,:b=>2]
      a = o.to_a
      a.assert.include?([:a,1])
      a.assert.include?([:b,2])
      a.size.assert == 2
    end
  end

  method :to_h do
    test do
      o = BasicCascade[:a=>1]
      assert_equal({:a=>1}, o.to_h)
    end
  end

  method :merge! do
    test 'can merge from hash' do
      o = BasicCascade[:f0=>"f0"]
      h = { :h0=>"h0" }
      r = BasicCascade[:f0=>"f0", :h0=>"h0"]
      assert_equal(r, o.merge!(h))
      #assert_equal({:f0=>"f0", :h0=>"h0"}, h.merge(o))
    end
  end

  method :update do
    test 'can update from hash' do
      o = BasicCascade[:f1=>"f1"]
      o.update(:h1=>"h1")
      assert_equal(o, BasicCascade[:f1=>"f1", :h1=>"h1"])
    end
  end

  method :method_missing do
    test "writer and reader" do
      o = BasicCascade.new
      10.times{ |i| o.__send__("n#{i}=", 1 ) }
      10.times{ |i| assert_equal(1, o.__send__("n#{i}")) }
    end
  end

  method :<< do
    test do
      c = BasicCascade.new
      c << [:x,8]
      c << [:y,9]

      assert_equal(8, c.x)
      assert_equal(9, c.y)
    end
  end

end

testcase Hash do

  method :update do
    test "hash can be updated by BasicCascade" do
      o = BasicCascade[:f1=>"f1"]
      h = {:h1=>"h1"}
      h.update(o)
      h.assert == {:f1=>"f1", :h1=>"h1"}
    end
  end

end
