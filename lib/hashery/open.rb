module Hashery

  #
  module Open

    FILTER = /(^__|^instance_|^object_|^\W|^as$|^send$|^class$|\?$)/

    #
    # When included into a class, all methods are made private with
    # a few exceptions.
    #
    def self.included(base)
      methods = base.public_instance_methods.select{ |m| m !~ FILTER }
      base.__send__(:private, *methods)
    end

    # Omit specific Hash methods from slot protection.
    def omit!(*methods)
      methods.reject!{ |x| x.to_s =~ /^__/ }
      (class << self; self; end).class_eval{ private *methods }
    end

    #
    def method_missing(s,*a, &b)
      type = s.to_s[-1,1]
      name = s.to_s.sub(/[!?=]$/, '')
      key  = name.to_sym

      case type
      when '='
        self[key] = a.first
      when '!'
        # call an underlying private method
        # TODO: limit this to omitted methods (from included) ?
        __send__(name, *a, &b)
      when '?'
        key?(key)
      else
        if key?(key)
          self[key]
        else
          super(s,*a,&b)
        end
      end
    end

  end

end
