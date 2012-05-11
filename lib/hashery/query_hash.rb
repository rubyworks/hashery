require 'hashery/crud_hash'

module Hashery

  # QueryHash is essentially a Hash class, but with some OpenStruct-like features.
  #
  #   q = QueryHash.new
  #
  # Entries can be added to the Hash via a setter method.
  #
  #   q.a = 1
  #
  # Then looked up via a query method.
  #
  #   q.a?  #=> 1
  #
  # The can also be looked up via a bang method.
  # 
  #   q.a!  #=> 1
  #
  # The difference between query methods and bang methods is that the bang method
  # will auto-instantiate the entry if not present, where as a query method will not.
  #
  # A QueryHash might not be quite as elegant as an OpenHash in that reader
  # methods must end in `?` or `!`, but it remains fully compatible with Hash
  # regardless of it's settings.
  #
  class QueryHash < CRUDHash

    #
    def <<(x)
      case x
      when Hash
        update(x)
      when Array
        x.each_slice(2) do |(k,v)|
          self[k] = v
        end
      end
    end

    # @todo Proper implementation for OpenHash#to_h ?
    def to_h
      dup
    end

    # @todo Proper implementation for OpenHash#to_hash ?
    def to_hash
      h = {}; each{ |k,v| h[k] = v }; h
    end

    # Route get and set calls.
    #
    #   o = OpenHash.new
    #   o.a = 1
    #   o.a?  #=> 1
    #   o.b?  #=> nil
    #
    def method_missing(s,*a, &b)
      type = s.to_s[-1,1]
      name = s.to_s.sub(/[!?=]$/, '')
      key  = name.to_sym

      case type
      when '='
        self[key] = a.first
      when '!'
        self[key]
      when '?'
        key?(key) ? fetch(key) : nil
      else
        # return self[key] if key?(key)
        super(s,*a,&b)
      end
    end

    #
    def respond_to?(name)
      return true if name.to_s.end_with?('=')
      return true if name.to_s.end_with?('?')
      return true if name.to_s.end_with?('!')
      #key?(name.to_sym) || super(name)
      super(name)
    end

  end

end
