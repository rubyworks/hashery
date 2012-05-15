class Hash

  # Create a hash given an `initial_hash`.
  def self.create(initial_data={}, &block)
    o = new &block
    o.update(initial_data)
    o
  end

  #
  alias :read :[]

  #
  def to_hash
    self  # -or- `h = {}; each{ |k,v| h[k] = v }; h` ?
  end

  #
  alias :to_h :to_hash

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
      case block.arity
      when 0
        raise ArgumentError, "arity of 0 for #{block.inspect}"
      when 2
        hash.each do |k,v|
          nk = block.call(k,v)
          hash2[nk] = v
        end
      else
        hash.each do |k,v|
          nk = block[k]
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

