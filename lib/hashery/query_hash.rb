# = QueryHash
#
# QueryHash is a similar to OpenHash. Like OpenHash,
# entries can be assigned via setter methods, but
# entries can only be looked up via query methods
# (i.e. methods ending in a ?-mark), hence the name
# of this class.
#
# A QueryHash is not quite as elegant as an OpenHash
# in that reader methods must end in ?-marks, but
# it remains fully compatible with Hash regardless
# of it's settings.

class QueryHash < Hash

  def to_h
    dup
  end

  def to_hash
    dup
  end

  def method_missing(s,*a,&b)
    case s.to_s
    when /\=$/
      self[s.to_s.chomp('=').to_sym] = a[0]
    when /\?$/
      self[s.to_s.chomp('?').to_sym]
    else
      super(s,*a,&b)
    end
  end

end
