require 'hashery/sparsearray'
require 'ae/legacy'

# This is a mostly complete testcase for SparseArray.
# SparseArray is tested by comparison to standard Array.

Case SparseArray do

  def aha(a)
    return a, SparseArray[*a]
  end

  Unit :to_ary do
    a, ha = aha [1,3,'a',8,nil,[1]]
    assert_equal(ha, ha.to_ary)  # these need to be opposite
  end

  Unit :to_a do
    a, ha = aha [1,3,'a',8,nil,[1]]
    assert_equal(a, ha.to_a)     #
    assert_equal(a.to_s, ha.to_s)
  end

  Unit :to_s do
    a, ha = aha [1,3,'a',8,nil,[1]]
    assert_equal(a.to_s, ha.to_s)
  end

  Unit :|, :&, :+, :- do
    a, ha = aha [1,3,5,8,9]
    b, hb = aha [2,3,6,8,9]
    assert_equal(a | b, (ha | hb).to_a)
    assert_equal(a & b, (ha & hb).to_a)
    assert_equal(a + b, (ha + hb).to_a)
    assert_equal(a - b, (ha - hb).to_a)
  end

  Unit :* do
    a, ha = aha [1,3]
    assert_equal(a*3,(ha*3).to_a)
  end

  Unit :[]= do
    a, ha = aha [1,2,3,4]
    a[1..2] = [8,9]
    ha[1..2] = [8,9]
    assert_equal(a, ha.to_a)
  end

  Unit :assoc do
    a, ha = aha [[1,2],[3,4],[3,6]]
    assert_equal(a.assoc(3), ha.assoc(3).to_a)
  end

  Unit :at do
    a, ha = aha [4,5,6,6]
    assert_equal(a.at(0), ha.at(0))
    assert_equal(a.at(2), ha.at(2))
    assert_equal(a.at(4), ha.at(4))
    assert_equal(a.at(9), ha.at(9))
    assert_equal(a.at(-1), ha.at(-1))
    assert_equal(a.at(-3), ha.at(-3))
    assert_equal(a.at(-4), ha.at(-4))
    assert_equal(a.at(-5), ha.at(-5))
  end

  Unit :collect do
    a, ha = aha [4,5,6,6]
    assert_equal(a.collect{|e|e}, ha.collect{|e|e}.to_a)
    assert_equal(a.collect!{|e|e}, ha.collect!{|e|e}.to_a)
    assert_equal(a,ha.to_a)
  end

  Unit :compact do
    a, ha = aha [4,nil,5,nil,6]
    assert_equal(a.compact, ha.compact.to_a)
  end

  Unit :concat do
    a, ha = aha [1,3,5,8,9]
    b, hb = aha [2,3,6,8,9]
    assert_equal(a.concat(b),ha.concat(hb).to_a)
  end

  Unit :count do
    ha = SparseArray[9,3,9,5,nil,nil,9,3]
    assert_equal(2,ha.count)
    assert_equal(2,ha.count(3))
    assert_equal(3,ha.count{|e|e==9})
  end

  Unit :delete do
    a, ha = aha [1,3,5,8,9,'a','b','c','c','d']
    # test delete
    assert_equal(a.delete(1),ha.delete(1))
    assert_equal(a,ha.to_a)
    assert_equal(a.delete('a'),ha.delete('a'))
    assert_equal(a,ha.to_a)
    # test delete_at
    assert_equal(a.delete_at(0),ha.delete_at(0))
    assert_equal(a,ha.to_a)
    # test delete_if
    assert_equal(a.delete_if{|v|v=='c'},ha.delete_if{|v|v=='c'}.to_a)
    assert_equal(a,ha.to_a)
  end

  Unit :each do
    a, ha = aha [4,'a',nil,'b']
    # test each
    ca, cha = '', ''
    a.each{|e| ca += e.to_s}
    ha.each{|e| cha += e.to_s}
    assert_equal(ca,cha)
    assert_equal(a,ha.to_a)
    # test each_index
    ca, cha = '', ''
    a.each_index{|i| ca += i.to_s}
    ha.each_index{|i| cha += i.to_s}
    assert_equal(ca,cha)
    assert_equal(a,ha.to_a)
  end

  Unit :eql? do
    a, ha = aha [4,'a',nil,'b']
    b, hb = aha [4,'a',nil,'b']
    assert_equal(a,b)
    assert_equal(ha,hb)
    assert_equal(a.eql?(b),ha.eql?(hb))
    assert_equal(b.eql?(a),hb.eql?(ha))
    assert(ha.eql?(hb))
    assert(hb.eql?(ha))
  end

  Unit :empty? do
    a, ha = aha []
    assert_equal(a.empty?,ha.empty?)
    a, ha = aha [1,2,3]
    assert_equal(a.empty?,ha.empty?)
  end

  Unit :fill do
    a, ha = aha ['a','b','c','d']
    assert_equal(a.fill('x'),ha.fill('x').to_a)
    assert_equal(a,ha.to_a)
    assert_equal(a.fill('y',2,2),ha.fill('y',2,2).to_a)
    assert_equal(a,ha.to_a)
    assert_equal(a.fill('z',0..1),ha.fill('z',0..1).to_a)
    assert_equal(a,ha.to_a)
  end

  Unit :first do
    a, ha = aha [2,3,4]
    assert_equal(a.first,ha.first)
  end

  Unit :flatten do
    a, ha = aha [2,[3],'a',[[1,2],4],nil,5]
    assert_equal(a.flatten,ha.flatten.to_a)
    a, ha = aha [2,[3],'a',[[1,2],4],nil,5]
    assert_equal(a.flatten!,ha.flatten!.to_a)
    assert_equal(a,ha.to_a)
    a, ha = aha [2,3,'a',nil,5]
    assert_equal(a.flatten!,ha.flatten!)
  end

  Unit :include? do
    a, ha = aha ['a','b','c','d']
    assert_equal(a.include?('b'),ha.include?('b'))
    assert_equal(a.include?('x'),ha.include?('x'))
  end

  Unit :index do
    a, ha = aha ['a','b','b','c','d']
    assert_equal(a.index('b'),ha.index('b'))
    assert_equal(a.index('x'),ha.index('x'))
  end

  Unit :join do
    a, ha = aha [2,3,4]
    assert_equal(a.join,ha.join)
    assert_equal(a.join(','),ha.join(','))
  end

  Unit :last do
    a, ha = aha [2,3,4]
    assert_equal(a.last,ha.last)
  end

  Unit :length do
    a, ha = aha [2,3,4]
    assert_equal(a.length,ha.length)
  end

  Unit :map! do
    a, ha = aha [4,5,6,6]
    assert_equal(a.map!{|e|e}, ha.map!{|e|e}.to_a)
    assert_equal(a,ha.to_a)
  end

  Unit :nitems do
    a, ha = aha [4,5,nil,6,nil]
    assert_equal(a.nitems, ha.nitems)
  end

  Unit :pop do
    a, ha = aha [4,5,nil,6,nil]
    assert_equal(a.pop, ha.pop)
    assert_equal(a, ha.to_a)
    assert_equal(a.pop, ha.pop)
    assert_equal(a, ha.to_a)
  end

  Unit :push do
    a, ha = aha [4,5,nil,6,nil]
    args = [1,2,3]
    assert_equal(a.push(*args), ha.push(*args).to_a)
    assert_equal(a, ha.to_a)
  end

  Unit :rassoc do
    a, ha = aha [[1,2],[1,3],[1,3]]
    assert_equal(a.rassoc(3), ha.rassoc(3).to_a)
  end

  Unit :reject! do
    a, ha = aha ['a','b','c','c','d']
    assert_equal(a.reject!{|v|v=='c'},ha.reject!{|v|v=='c'}.to_a)
    assert_equal(a,ha.to_a)
    assert_equal(a.reject!{|v|v=='x'},ha.reject!{|v|v=='x'})
    assert_equal(a,ha.to_a)
  end

  Unit :reverse do
    a, ha = aha ['a','b','c','c','d']
    assert_equal(a.reverse,ha.reverse.to_a)
    assert_equal(a.reverse!,ha.reverse!.to_a)
    assert_equal(a,ha.to_a)
    a, ha = aha [1,2,3,'a','b','c']
    assert_equal(a.reverse!,ha.reverse!.to_a)
    assert_equal(a,ha.to_a)
  end

  Unit :reverse_each do
    a, ha = aha [4,'a',nil,'b']
    # test each
    ca, cha = '', ''
    a.reverse_each{|e| ca += e.to_s}
    ha.reverse_each{|e| cha += e.to_s}
    assert_equal(ca,cha)
    assert_equal(a,ha.to_a)
  end

  Unit :rindex do
    a, ha = aha ['a','b','c','c','d']
    assert_equal(a.rindex('c'),ha.rindex('c'))
    assert_equal(a.rindex('x'),ha.rindex('x'))
  end

  Unit :shift do
    a, ha = aha ['a','b','c','c','d']
    assert_equal(a.shift,ha.shift)
    assert_equal(a,ha.to_a)
  end

  Unit :slice do
    a, ha = aha [1,2,3,4]
    # test []
    assert_equal(a[1], ha[1])
    assert_equal(a[1..2], ha[1..2].to_a)
    assert_equal(a[1...2], ha[1...2].to_a)
    assert_equal(a[1..7], ha[1..7].to_a)
    assert_equal(a[1,2], ha[1,2].to_a)
    # test slice
    assert_equal(a.slice(1), ha.slice(1))
    assert_equal(a.slice(1..2), ha.slice(1..2).to_a)
    assert_equal(a.slice(1...2), ha.slice(1...2).to_a)
    assert_equal(a.slice(1...2), ha.slice(1...2).to_a)
    assert_equal(a.slice(1,2), ha.slice(1,2).to_a)
    # test slice!
    assert_equal(a.slice!(1..2), ha.slice!(1..2).to_a)
    assert_equal(a, ha.to_a)
  end

  Unit :sort do
    a, ha = aha [1,2,3,4]
    # test sort
    assert_equal(a.sort, ha.sort.to_a)
    #assert_equal(a.sort{|x,y| y<=>x}, ha.sort{|x,y| y<=>x}.to_a)
    # test sort!
    assert_equal(a.sort!, ha.sort!.to_a)
    assert_equal(a, ha.to_a)
  end

  Unit :uniq do
    a, ha = aha [1,1,2,3,3,4,5,6,6]
    assert_equal(a.uniq, ha.uniq.to_a)
  end

  Unit :uniq! do
    a, ha = aha [1,1,2,3,3,4,5,6,6]
    a.uniq!; ha.uniq!
    assert_equal(a, ha.to_a)
  end

  Unit :values_at do
    a, ha = aha ['a','b','c','d']
    assert_equal(a.values_at(1,3),ha.values_at(1,3).to_a)
  end

  Unit :unshift do
    a, ha = aha ['a','b','c','c','d']
    assert_equal(a.unshift('x'),ha.unshift('x').to_a)
    assert_equal(a,ha.to_a)
  end
end

