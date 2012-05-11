module Hashery

  # A PropertyHash is the same as a regular Hash except it strictly limits the
  # allowed keys.
  #
  # There are two ways to use it.
  #
  # 1) As an object in itself.
  #
  #   h = PropertyHash.new(:a=>1, :b=>2)
  #   h[:a]        #=> 1
  #   h[:a] = 3
  #   h[:a]        #=> 3
  #
  # But if we try to set key that was not fixed, then we will get an error.
  #
  #   h[:x] = 5    #=> ArgumentError
  # 
  # 2) As a superclass.
  #
  #   class MyPropertyHash < PropertyHash
  #     property :a, :default => 1
  #     property :b, :default => 2
  #   end
  #
  #   h = MyPropertyHash.new
  #   h[:a]        #=> 1
  #   h[:a] = 3
  #   h[:a]        #=> 3
  #
  # Again, if we try to set key that was not fixed, then we will get an error.
  #
  #   h[:x] = 5    #=> ArgumentError
  #
  class PropertyHash < ::Hash

    #
    def self.properties
      @properties ||= (
        parent = ancestors[1]
        if parent.respond_to?(:properties)
          parent.properties
        else
          {}
        end
      )
    end

    #
    def self.property(key, opts={})
      properties[key] = opts[:default]
    end

    #
    def initialize(properties={})
      super()
      fixed = self.class.properties.merge(properties)
      replace(fixed)
    end

    #
    def []=(k,v)
      assert_key!(k)
      super(k,v)
    end

    #
    def update(h)
      h.keys.each{ |k| assert_key!(k) }
      super(h)
    end

    #
    def merge!(h)
      h.keys.each{ |k| assert_key!(k) }
      super(h)
    end

    #
    def <<(a)
      k,v = *a
      self[k] = v
    end

    # Add a new acceptable key.
    # TODO: Should this be supported?
    def accept_key!(k,v=nil)
      self[k] = v
    end

  private

    def assert_key!(key)
      unless key?(key)
        raise ArgumentError, "The key '#{key}' is not defined for this FixedHash."
      end
    end

  end

end
