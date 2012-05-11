# OpensStructable is a mixin module which can provide OpenStruct behavior to
# any class or object. OpenStructable allows extention of data objects
# with arbitrary attributes.
#
#   require 'ostructable'
#
#   class Record
#     include OpenStructable
#   end
#
#   record = Record.new
#   record.name    = "John Smith"
#   record.age     = 70
#   record.pension = 300
#
#   puts record.name     # -> "John Smith"
#   puts record.address  # -> nil
#
# @author 7rans
# @author Yukihiro Matsumoto
# @author Gavin Sinclair
#
module OpenStructable

  # TODO: Update to matchh current OpenStruct class.

  # TODO: Keep this uptodate with ostruct.rb.

  # TODO: See if Matz will accept it into core so we don't have to anymore.

  # TODO: As with OpenStruct, marshalling is problematic at the moment.

  def self.include(base)
    if Hash > base
      base.module_eval do
        define_method(:__table__) do
          self
        end
      end
      protected :__table__
    end
  end

  def initialize(hash=nil)
    @__table__ = {}
    if hash
      for k,v in hash
        __table__[k.to_sym] = v
        new_ostruct_member(k)
      end
    end
  end

  #
  def __table__
    @__table__ ||= {}
  end
  protected :__table__

  # duplicate an OpenStruct object members.
  def initialize_copy(orig)
    super
    __table__.replace(__table__.dup)
  end

  def marshal_dump
    __table__
  end

  def marshal_load(hash)
    __table__.replace(hash)
    __table__.each_key{|key| new_ostruct_member(key)}
  end

  def new_ostruct_member(name)
    unless self.respond_to?(name)
      self.instance_eval %{
        def #{name}; __table__[:#{name}]; end
        def #{name}=(x); __table__[:#{name}] = x; end
      }
    end
  end

  #
  # Generate additional attributes and values.
  #
  def update(hash)
    #__table__ ||= {}
    if hash
      for k,v in hash
        __table__[k.to_sym] = v
        new_ostruct_member(k)
      end
    end
  end

  #
  def method_missing(mid, *args) # :nodoc:
    mname = mid.to_s
    len = args.length
    if mname =~ /=$/
      if len != 1
        raise ArgumentError, "wrong number of arguments (#{len} for 1)", caller(1)
      end
      if self.frozen?
        raise TypeError, "can't modify frozen #{self.class}", caller(1)
      end
      mname.chop!
      #@__table__ ||= {}
      __table__[mname.intern] = args[0]
      self.new_ostruct_member(mname)
    elsif len == 0
      #@__table__ ||= {}
      __table__[mid]
    else
      raise NoMethodError, "undefined method `#{mname}' for #{self}", caller(1)
    end
  end

  #
  # Remove the named field from the object.
  #
  def delete_field(name)
    #@__table__ ||= {}
    __table__.delete(name.to_sym)
  end

  #
  # Returns a string containing a detailed summary of the keys and values.
  #
  def inspect
    str = "<#{self.class}"
    for k,v in (@__table__ ||= {})
      str << " #{k}=#{v.inspect}"
    end
    str << ">"
  end

  # TODO: OpenStruct could be compared too, but only if it is loaded. How?

  #
  # Compare this object and +other+ for equality.
  #
  def ==(other)
    case other
    when OpenStructable
      __table__ == other.__table__
    #when OpenStruct
    #  __table__ == other.__table__
    when Hash
      __table__ == other
    else
      false
    end
  end

end

=begin
#
# It is possibe to implement OpenStruct itself with
# this OpenStructable module as follows:
#
class OpenStruct
  include OpenStructable
end
=end
