require 'hashery/crud_hash'

module Hashery

  # OpenHash is a Hash, but also supports open properties much like
  # OpenStruct.
  #
  # Only names that are name methods of Hash can be used as open slots.
  # To open a slot for a name that would otherwise be a method, the 
  # method needs to be made private. The `#open!` method can be used
  # to handle this.
  #
  #   o = OpenHash.new
  #   o.open!(:send)
  #   o.send = 4
  #
  class OpenHash < CRUDHash

    alias :object_class :class

    #FILTER  = /(^__|^\W|^instance_|^object_|^to_)/
    #methods = Hash.instance_methods(true).select{ |m| m !~ FILTER }
    #methods = methods - [:each, :inspect, :send]  # :class, :as]
    #private *methods

    #
    # Open up a slot that that would normally be a Hash method.
    #
    # The only methods that can't be opened are ones starting with `__`.
    #
    def open!(*methods)
      methods.reject!{ |x| x.to_s =~ /^__/ }
      (class << self; self; end).class_eval{ private *methods }
    end

    # @deprected
    alias :omit! :open!

    #
    # Is a slot open?
    #
    def open?(method)
      ! public_methods(true).include?(method.to_sym)
    end

    #
    # Make specific Hash methods available for use that have previously opened.
    #
    def close!(*methods)
      (class << self; self; end).class_eval{ public *methods }
    end

    #
    def method_missing(s,*a, &b)
      type = s.to_s[-1,1]
      name = s.to_s.sub(/[!?=]$/, '')
      key  = name.to_sym

      case type
      when '='
        #open!(key) unless open?(key)
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
