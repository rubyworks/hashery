# = SparseArray
#
# SparseArray is an implemenation of the Array class using only Hashes.
# Regular Arrays are never used except once to delegate the #pack method,
# (and *args parameters of course). SparseArray is almost fully compatible
# with Array. There are still a few missing methods that came in with
# Ruby 1.9 that need to be added, and negative indexes are not quite fully
# supported yet.
#
# Benchmarks comparing Ruby 1.6 circa 2004 compared to Ruby 1.8.7 
# circa 2010, show that Ruby's Array implementation has improved quite
# a bit. Where as Array was about 2-4 times faster than SparseArray in 2004,
# it is now over 10x faster, and able to handle large sparse arrays quite
# easily. Though surely SparseArray could still be improved, <b>SparseArray
# is little more than an interesting novelty at this point</b>, as opposed
# to a useful class, but we will keep her nonetheless for simple interests
# sake.
# 
# NOTE: SparseArray is also the first piece of code I used TDD to create.
#
# Copyright (c) 2004 Thomas Sawyer
#
#--
# TODO: Add auto-array features if needed (see work/autoarray).
#++

class SparseArray < Hash

  def self.[](*args)
    s = new
    args.each{ |e| s << e }
    s
  end

  def self.new_h(hsh)
    nha = new
    nha.replace(hsh)
    #nha.reindex!
  end

  def initialize(i=0,e=nil)
    if i > 0
      i.times { set(self.length,e) }
    end
  end

  def &(ha)
    nha = self.class.new
    (0..self.length-1).each do |i|
      if ha.has_value?(self.fetch(i)) and !nha.has_value?(self.fetch(i))
        nha.set(nha.length,self.fetch(i))
      end
    end
    nha
  end

  def *(j)
    if j.kind_of?(String)
      return self.join(j)
    else
      nha = self.class.new
      j.times { (0...self.length).each { |i| nha.set(nha.length,self.fetch(i)) } }
      return nha
    end
  end

  def +(ha)
    nha = self.dup
    (0..ha.length-1).each { |i| nha.set(nha.length,ha.fetch(i)) }
    nha
  end

  def -(ha)
    nha = self.class.new
    self.each { |v| nha << v if !ha.has_value?(v) }
    #ha.each { |v| nha << i if !self.include?(v) }
    nha
  end

  def <<(e)
    set(length,e)
    self
  end

  def <=>(ha)
    (0..self.length-1).each do |i|
      ieq = (self.fetch(i) <=> ha.fetch(i))
      return ieq if ieq != 0
    end
    self.length <=> ha.length
  end

  def ===(ha)
    self.==(ha)
  end

  alias_method :get, :[]
  private :get

  # TODO: Ranges with negative indexes not yet supported.
  def [](i,l=nil)
    if l
      i = size + i if i < 0
      i = i...i+l
    elsif ! i.kind_of?(Range)
      return self.at(i)
    end
    nha = self.class.new
    i.each { |j| nha.set(nha.length,get(j)) if has_key?(j) }
    nha
  end

  alias set []=
  protected :set

  def []=(i,b,c=nil)
    if c
      rng = (Integer(i)..Integer(i+b))
      b = c
    elsif i.kind_of? Range
      rng = i
    else
      self.set(Integer(i),b)
      return b
    end
    if b == nil
      rng.each { |i| qdelete(i) }
      self.reindex!
    elsif b.kind_of?(Array) or b.kind_of?(self.class)
      j = 0
      rng.each { |i| self[i] = b[j]; j+=1 }
    else
      rng.each { |i| qdelete(i) }
      self[rng.fist] = b
      self.reindex!
    end
  end

  def |(ha)
    nha = self.dup
    ha.each { |v| nha << v if !nha.has_value?(v) }
    nha
  end

  def assoc(k)
    (0...self.length).each { |i| return self.fetch(i) if self.fetch(i)[0] == k }
    return nil
  end

  def at(i)
    i = self.length + i if i <= -1
    get(i)
    #return nil if i < 0 or i >= self.length
    #return self.fetch(i)
  end

  #def choice
  #end

  # clear okay

  #
  def collect
    nha = self.class.new
    (0...self.length).each { |i| nha << yield(self.fetch(i)) }
    nha
  end

  def collect!
    nha = self.class.new
    (0...self.length).each { |i| nha << yield(self.fetch(i)) }
    self.replace(nha)
  end

  #def combination
  #end

  #
  def compact
    nha, j = self.class.new, 0
    (0..self.length-1).each do |i|
      if self.fetch(i) != nil
        nha.set(j,self.fetch(i))
        j+=1
      end
    end
    nha
  end

  def compact!
    if self.has_value?(nil)
      nha, j = self.class.new, 0
      (0..self.length-1).each do |i|
        if self.fetch(i) != nil
          nha.set(j,self.fetch(i))
          j+=1
        end
      end
      return self.replace(nha)
    else
      return nil
    end
  end

  #
  def concat(ha)
    (0...ha.length).each { |i| self.set(self.length,ha.fetch(i)) }
    self
  end

  def count(e=nil)
    if block_given?
      cnt = 0
      (0...self.length).each { |i| cnt += 1 if yield(self.fetch(i)) }
      return cnt
    else
      cnt = 0
      (0...self.length).each { |i| cnt += 1 if self.fetch(i) == e }
      return cnt
    end
  end

  #
  alias qdelete delete
  private :qdelete

  #
  def delete(e)
    if has_value?(e)
      qdelete_if { |i,v| v == e }
      reindex!
      return e
    else
      return yield if block_given?
      return nil
    end
  end

  #
  def delete_at(i)
    if self.has_key?(i)
      e = self.fetch(i)
      qdelete(i)
      reindex!
      return e
    else
      return nil
    end
  end

  alias qdelete_if delete_if
  private :qdelete_if

  #
  def delete_if
    qdelete_if { |i,v| yield(v) }
    reindex!
  end

  def each
    (0...self.length).each{ |i| yield(get(i)) }
  end

  def each_index
    (0...self.length).each{ |i| yield(i) }
  end

  # empty? okay as is

  def eql?(ha)
    return false if self.length != ha.length
    return true if (0...self.length).all? { |i| self.fetch(i).eql?(ha.fetch(i)) }
    return false
  end

  def fill(f,s=nil,l=nil)
    if s.kind_of?(Range)
      r = s
    else
      s = 0 if !s
      l = self.length - s if !l
      r = s...(s+l)
    end
    r.each{ |i| self.set(i,f) }
    self
  end

  def first
    return nil if self.empty?
    self.fetch(0)
  end

  def flatten
    nha = self.class.new
    (0...self.length).each do |i|
      sfi = self.fetch(i)
      if sfi.kind_of?(self.class) or sfi.kind_of?(Array)
        nha.concat(sfi.flatten)
      else
        nha.set(nha.length,sfi)
      end
    end
    nha
  end

  def flatten!
    return nil if !self.any? { |e| e.kind_of?(self.class) or e.kind_of?(Array) }
    self.replace(self.flatten)
  end

  def include?(v)
    self.has_value?(v)
  end

  #
  def insert(index, *objs)
    index = size + index + 1 if index < 0
    tail = self[index...size]
    objs.each_with_index do |obj, i|
      set(index + i, obj)
    end
    tail.each_with_index do |obj, i|
      set(objs.size + index + i, obj)
    end
    self
  end

  # index okay

  #
  def join(sep='')
    s = ''
    (0...self.length).each { |i| s << "#{self.fetch(i)}#{sep}" }
    return s.chomp(sep)
  end

  #
  def last
    self[self.length-1]
  end

  # length okay

  #
  alias map! collect!

  #
  def nitems
    cnt = 0
    (0...self.length).each { |i| cnt += 1 if self.fetch(i) != nil }
    cnt
  end

  def pack(*args)
    self.to_a.pack(*args)
  end

  #def permutation
  #end

  #
  def pop
    self.delete_at(self.length-1)
  end

  #def product
  #end

  #
  def push(*e)
    self.concat(e)
  end

  def rassoc(k)
    (0...self.length).each { |i| return self.fetch(i) if self.fetch(i)[1] == k }
    return nil
  end

  def reindex
    nha, j, k, tl = self.class.new, 0, 0, self.length
    while k < tl
      if self.has_key?(j)
        nha.set(k,self.fetch(j))
        j+=1; k+=1
      else
        j+=1
      end
    end
    nha
  end

  #
  def reindex!
    self.replace(self.reindex)
  end

  #
  def index(*args)
    key(*args)
  end

  def reject!
    chg=nil
    qdelete_if { |i,v| r=yield(v); chg=true if r; r }
    return nil if !chg
    reindex!
  end

  #def replace(ha)
  #  if ha.length < self.length
  #    (ha.length..self.length-1).each { |i| self.delete(i) }
  #    (0..ha.length-1).each { |i| self.set(i,ha[i]) }
  #  end
  #end

  def reverse
    nha = self.class.new
    (0...self.length).each { |i| nha.set(self.length-1-i,self.fetch(i)) }
    nha
  end

  def reverse!
    (0...self.length/2).each do |i|
      ri = self.length-1-i
      tmp = self.fetch(ri)
      self.set(ri,self.fetch(i))
      self.set(i,tmp)
    end
    self
  end

  def reverse_each
    i = self.length - 1
    while i >= 0
      yield(self.fetch(i))
      i -= 1
    end
  end

  def rindex(e)
    i = self.length - 1
    while i >= 0
      return i if self.fetch(i) == e
      i -= 1
    end
    return nil
  end

  def shift
    e1 = self[0]
    tl = self.length - 1
    (1..tl).each { |i| self.set(i-1,self.fetch(i)) }
    self.delete_at(tl)
    e1
  end

  #
  def shuffle
    dup.shuffle!
  end

  #
  def shuffle!
    size.times do
      a = rand(size).to_i
      b = rand(size).to_i
      self[a], self[b] = self[b], self[a]
    end 
  end

  # size okay

  #
  def slice(*args)
    self[*args]
  end

  def slice!(*args)
    result = self[*args]
    self[*args] = nil
    result
  end

  def sort
    raise "SparseArray does not currently support sorting with blocks" if block_given?
    nha = self.dup
    qsort(nha,0,nha.length-1)
  end

  def qsort(ha, l, r)
    l_hold = l
    r_hold = r
    pivot = ha[l]
    while l < r
      r -= 1 while (ha[r] <=> pivot) >= 0 and l < r
      if l != r
        ha[l] = ha[r]
        l += 1
      end
      l += 1 while (ha[l] <=> pivot) <= 0 and l < r
      if l != r
        ha[r] = ha[l]
        r -= 1
      end
    end
    ha[l] = pivot
    pivot = l
    l = l_hold
    r = r_hold
    qsort(ha,l,pivot-1) if l < pivot
    qsort(ha,pivot+1,r) if r > pivot
    ha
  end

  def sort!
    raise "SparseArray does not currently support sorting with blocks" if block_given?
    qsort(self,0,self.length-1)
  end

  def to_a
    a = []
    (0..self.length-1).each { |i| a << self.fetch(i) }
    a
  end

  def to_ary
    self
  end

  def to_h
   h = Hash.new
   self.each { |k,v| h[k] = v }
   h
  end

  def to_s
    self.to_a.to_s
  end

  #
  #def transpose
  #end

  #
  def uniq
    nha = self.class.new
    (0..self.length-1).each do |i|
      nha[nha.length] = self[i] if !nha.has_value?(self[i])
    end
    nha
  end

  #
  def uniq!
    j = 0
    (1..self.length-1).each do |i|
      if !self[0..j].has_value?(self[i])
        self[j+1] = self[i]
        j+=1
      end
    end
    (j+1..self.length-1).each { |i| qdelete(i) }
  end

  def unshift(e)
    i = self.length - 1
    while i >= 0
      self.set(i+1,self.fetch(i))
      return i if self.fetch(i) == e
      i -= 1
    end
    self.set(0,e)
    self
  end

  def values_at(*ix)
    nha = self.class.new
    ix.each {|i| nha[nha.length] = self.at(i)}
    nha
  end

end

