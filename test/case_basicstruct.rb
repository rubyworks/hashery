require 'hashery/basicstruct'
require 'ae/legacy'

TestCase BasicStruct do
  include AE::Legacy::Assertions

  Unit :respond_to? do
    o = BasicStruct.new
    o.assert.respond_to?(:key?)
  end

  Unit :is_a? do
    assert BasicStruct[{}].is_a?(Hash)
    assert BasicStruct[{}].is_a?(BasicStruct)
  end

  Unit :[] => "subhash access" do
    o = BasicStruct[:a=>1,:b=>{:x=>9}]
    assert{ o[:b][:x] == 9 }
    assert{ o.b[:x] == 9 }
  end

  Unit :[] => "indifferent key access" do
    o = BasicStruct["a"=>1,"b"=>{:x=>9}]
    assert{ o["a"] == 1 }
    assert{ o[:a] == 1 }
    assert{ o["b"] == {:x=>9} }
    assert{ o[:b] == {:x=>9} }
    assert{ o["b"][:x] == 9 }
    assert{ o[:b]["x"] == nil }
  end

  Unit :[]= => "setting first entry" do
    f0 = BasicStruct.new
    f0[:a] = 1
    assert{ f0.to_h == {:a=>1} }
  end

  Unit :[]= => "setting an additional entry" do
    f0 = BasicStruct[:a=>1]
    f0[:b] = 2
    assert{ f0.to_h == {:a=>1,:b=>2} }
  end

  Unit :method_missing => "reading entries" do
    f0 = BasicStruct[:class=>1]
    assert{ f0.class  == 1 }
  end

  Unit :method_missing => "setting entries" do
    fo = BasicStruct.new
    9.times{ |i| fo.__send__("n#{i}=", 1) }
    9.times{ |i|
      assert( fo.__send__("n#{i}") == 1 )
    }
  end

  Unit :method_missing => "using bang" do
    o = BasicStruct.new
    o.a = 10
    o.b = 20
    h = {}
    o.each!{ |k,v| h[k] = v + 10 }
    assert( h == {:a=>20, :b=>30} )
  end

  #Unit :as_hash do
  #  f0 = BasicStruct[:f0=>"f0"]
  #  h0 = { :h0=>"h0" }
  #  assert{ BasicStruct[:f0=>"f0", :h0=>"h0"] == f0.as_hash.merge(h0) }
  #  assert{  {:f0=>"f0", :h0=>"h0"} == h0.merge(f0) }
  #end

  Unit :as_hash do
    f1 = BasicStruct[:f1=>"f1"]
    h1 = { :h1=>"h1" }
    f1.as_hash.update(h1)
    h1.update(f1)
    assert{ f1 == BasicStruct[:f1=>"f1", :h1=>"h1"] }
    assert{ h1 == {:f1=>"f1", :h1=>"h1"} }
  end

  Unit :<< => "passing a hash" do
    fo = BasicStruct.new
    fo << {:a=>1,:b=>2}
    assert{ fo.to_h == {:a=>1, :b=>2} }
  end

  Unit :<< => "passing a pair" do
    fo = BasicStruct.new
    fo << [:a, 1]
    fo << [:b, 2]
    assert( fo.to_h == {:a=>1, :b=>2} )
  end

  Unit :to_h do
    ho = {}
    fo = BasicStruct.new
    5.times{ |i| ho["n#{i}".to_sym] = 1 }
    5.times{ |i| fo.__send__("n#{i}=", 1) }
    assert{ fo.to_h == ho  }
  end

  Unit :to_h => "BasicStruct within BasicStruct" do
    o = BasicStruct.new
    o.a = 10
    o.b = 20
    o.x = BasicStruct.new
    o.x.a = 100
    o.x.b = 200
    o.x.c = 300
    assert{ o.to_h == {:a=>10, :b=>20, :x=>{:a=>100, :b=>200, :c=>300}} }
  end

  Unit :to_proc do
    p = lambda { |x| x.word = "Hello" }
    o = BasicStruct[:a=>1,:b=>2]
    assert{ Proc === o.to_proc }
  end

end

TestCase Hash do

  Unit :to_basicstruct do
    h = {'a'=>1, 'b'=>2}
    o = h.to_basicstruct
    o.a.assert == 1
    o.b.assert == 2
  end

end

=begin
TestCase Proc do

  Unit :to_basicstruct do
    p = lambda { |x| x.word = "Hello" }
    o = p.to_basicstruct
    assert{ o.word == "Hello" }
  end

end
=end

