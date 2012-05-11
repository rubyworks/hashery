module Hashery

  # This module is included into Ruby's core Hash class.
  #
  # These method derive from Ruby Facets.
  module CoreExt

    #
    def to_h
      self
    end

    #
    def to_hash
      self
    end

    # Synonym for Hash#rekey, but modifies the receiver in place (and returns it).
    #
    #   foo = { :name=>'Gavin', :wife=>:Lisa }
    #   foo.rekey!{ |k| k.to_s }  #=>  { "name"=>"Gavin", "wife"=>:Lisa }
    #   foo.inspect               #=>  { "name"=>"Gavin", "wife"=>:Lisa }
    #
    def rekey(key_map=nil, &block)
      if !(key_map or block)
        block = lambda{|k| k.to_sym}
      end

      key_map ||= {} 

      hash = {}

      (keys - key_map.keys).each do |key|
        hash[key] = self[key]
      end

      key_map.each do |from, to|
        hash[to] = self[from] if key?(from)
      end

      hash2 = {}

      if block
        if block.arity == 1  # TODO: is this condition needed?
          hash.each do |k,v|
            nk = block[k]
            #nk = (NA == nk ? k : nk)  # TODO: Can't support this here.
            hash2[nk] = v
          end
        else
          hash.each do |k,v|
            nk = block[k,v]
            #nk = (NA == nk ? k : nk)  # TODO:
            hash2[nk] = v
          end
        end
      else
        hash2 = hash
      end

      hash2
    end

    # Synonym for Hash#rekey, but modifies the receiver in place (and returns it).
    #
    #   foo = { :name=>'Gavin', :wife=>:Lisa }
    #   foo.rekey!{ |k| k.to_s }  #=>  { "name"=>"Gavin", "wife"=>:Lisa }
    #   foo                       #=>  { "name"=>"Gavin", "wife"=>:Lisa }
    #
    # CREDIT: Trans, Gavin Kistner

    def rekey!(key_map=nil, &block)
      replace(rekey(key_map, &block))
    end

  end

end

class Hash #:nodoc:
  include Hashery::CoreExt
end
