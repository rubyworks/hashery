class OpenQuery < Hash
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

