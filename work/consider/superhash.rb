class SuperHash < Hash
  def initialize
    super { |h, k| h[k] = SuperHash.new }
  end
end

